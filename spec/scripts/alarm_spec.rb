require 'spec_helper'
require 'script_runner'

describe "Script alarms" do
  before :each do
    @remote_session = RemoteSession.get(nil)

    @safe_script = %{get "http://velti.com/"; get "http://google.com/"}
    @alarm_script = %{#{@safe_script}; alarm "alarm message"}

    @good_velti = "good velti"
    @good_google = "good google"

    @bad_velti = "<html><body>some rubbish</body></html>"
    @bad_google = "<html><body>some rubbish</body></html>"
    @api_method = FactoryGirl.create(:api_method, :script => @alarm_script)
  end

  def stub_good_requests
    stub_request(:get, "http://velti.com/").to_return(
      :body => @good_velti,
      :status => 200, :headers => { 'Content-Type' => 'text/html; charset=UTF-8'}
    )
    stub_request(:get, "http://google.com/").to_return(
      :body => @good_google, :status => 200,
      :headers => { 'Content-Type' => 'text/html; charset=UTF-8'}
    )
  end

  def stub_alarm_requests
    stub_request(:get, "http://velti.com/").to_return(
      :body => @bad_velti, :status => 200,
      :headers => { 'Content-Type' => 'text/html; charset=UTF-8'}
    )
    stub_request(:get, "http://google.com/").to_return(
      :body => @bad_google, :status => 200,
      :headers => { 'Content-Type' => 'text/html; charset=UTF-8'}
    )
  end

  it "creates an alarm object" do
    stub_alarm_requests
    lambda do
      @api_method.run_script({}, @remote_session)
    end.should change(Alarm, :count).by(1)
  end

  it "sets the api_method for the alarm" do
    stub_alarm_requests
    @api_method.run_script({}, @remote_session)
    alarm = Alarm.last
    alarm.api_method.should == @api_method
  end

  it "stores the alarm message" do
    stub_alarm_requests
    @api_method.run_script({}, @remote_session)
    alarm = Alarm.last
    alarm.message.should == "alarm message"
  end

  it "stores the responses with 'last_good' for the user" do
    remote_session = RemoteSession.get(nil)
    id = remote_session.id

    stub_good_requests
    @api_method.script = @safe_script
    @api_method.run_script({}, remote_session)

    stub_alarm_requests
    new_remote_session = RemoteSession.get(id)
    @api_method.script = @alarm_script
    @api_method.run_script({}, new_remote_session)

    alarm = Alarm.last
    alarm.parsed_responses.should include( {
      "request_url" => "http://velti.com/",
      "request_method" => "get",
      "alarm_response" => @bad_velti,
      "last_good_response" => @good_velti
    } )

    alarm.parsed_responses.should include( {
      "request_url" => "http://google.com/",
      "request_method" => "get",
      "alarm_response" => @bad_google,
      "last_good_response" => @good_google
    } )
  end

  it "stores the responses with 'last_good' for any other" do
    remote_session = RemoteSession.get(nil)

    stub_good_requests
    @api_method.script = @safe_script
    @api_method.run_script({}, remote_session)

    stub_alarm_requests
    new_remote_session = RemoteSession.get(nil)
    @api_method.script = @alarm_script
    @api_method.run_script({}, new_remote_session)

    alarm = Alarm.last
    alarm.parsed_responses.should include( {
      "request_url" => "http://velti.com/",
      "request_method" => "get",
      "alarm_response" => @bad_velti,
      "last_good_response" => @good_velti
    } )

    alarm.parsed_responses.should include( {
      "request_url" => "http://google.com/",
      "request_method" => "get",
      "alarm_response" => @bad_google,
      "last_good_response" => @good_google
    } )
  end

  it "creates an alarm job in resque" do
    stub_alarm_requests
    @api_method.run_script({}, @remote_session)
    alarm = Alarm.last
    FootprintsAlarmNotifier.should have_queued(alarm.id).in(:footprints_notifications)
  end

  describe "rate limiting" do
    before :each do
      stub_alarm_requests
      @redis_key = "alarm:#{@api_method.site.name}:#{@api_method.name}:alarm_id"
    end

    it "does not create multiple alarms" do
      lambda do
        2.times { @api_method.run_script({}, @remote_session) }
      end.should change(Alarm, :count).by(1)
    end

    it "increments the alarm counter" do
      2.times { @api_method.run_script({}, @remote_session) }
      Alarm.last.count.should == 2
    end

    it "sets the TTL on the redis key" do
      @api_method.run_script({}, @remote_session)
      $redis.ttl(@redis_key).should be_> 0
    end

    it "generates a new alarm after the redis key expires" do
      lambda do
        @api_method.run_script({}, @remote_session)
        # Fake the key expiry
        $redis.del(@redis_key)
        @api_method.run_script({}, @remote_session)
      end.should change(Alarm, :count).by(2)
    end
  end
end

