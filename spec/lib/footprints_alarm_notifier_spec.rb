require 'spec_helper'
require_dependency "footprints_alarm_notifier"

describe FootprintsAlarmNotifier do
  describe "config" do
    it "returns the footprints web services uri" do
      FootprintsAlarmNotifier.ws_uri.should == "http://10.50.1.196/MRcgi/MRWebServices.pl"
    end

    it "returns the footprints namespace" do
      FootprintsAlarmNotifier.namespace.should == "http://10.50.1.196/MRWebServices"
    end

    it "returns the footprints project id" do
      FootprintsAlarmNotifier.project_id.should == 12
    end

    it "returns the footprints username" do
      FootprintsAlarmNotifier.username.should == 'footprints.user'
    end

    it "returns the footprints password" do
      FootprintsAlarmNotifier.password.should == 'footprints.password'
    end

    it "returns the webadapter host to use for links back to alarms" do
      FootprintsAlarmNotifier.alarm_host.should == 'test.webadapter2'
    end
  end

  describe 'perform' do
    before :each do
      @message = "An alarm message"
      @alarm = FactoryGirl.create(:alarm, :message => @message)
      @site = @alarm.site

      footprints_response = File.read(File.join(Rails.root, "spec", "fixtures", "www", "footprints"))
      stub_request(:post, FootprintsAlarmNotifier.ws_uri).to_return(
        :body    => footprints_response,
        :status  => 200,
        :headers => { 'ContentType' => 'text/xml; charset=utf-8' }
      )
    end

    it "should send a request to the footprints web service api" do
      FootprintsAlarmNotifier.perform(@alarm.id)

      link_to_alarm = "http://test.webadapter2/sites/#{@site.to_param}/api_methods/#{@alarm.api_method.id}/alarms/#{@alarm.id}"
      project_id = FootprintsAlarmNotifier.project_id
      username   = FootprintsAlarmNotifier.username
      password   = FootprintsAlarmNotifier.password
      priority   = 1

      # Apologies in advance for the hardcoded XML
      soap_body = %{<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><MRWebServices__createIssue xmlns="http://10.50.1.196/MRWebServices"><c-gensym3 xsi:type="xsd:string">#{username}</c-gensym3><c-gensym5 xsi:type="xsd:string">#{password}</c-gensym5><c-gensym7 xsi:type="xsd:string" /><c-gensym9><priorityNumber xsi:type="xsd:int">#{priority}</priorityNumber><status xsi:type="xsd:string">Open</status><projectID xsi:type="xsd:int">#{project_id}</projectID><title xsi:type="xsd:string">Webadapter: alarm for #{@site.name}</title><description xsi:type="xsd:string">#{@message}\n\n#{link_to_alarm}</description></c-gensym9></MRWebServices__createIssue></soap:Body></soap:Envelope>}
      a_request(:post, FootprintsAlarmNotifier.ws_uri).with(:body  => soap_body).should have_been_made
    end

    it "sets the http soap header" do
      FootprintsAlarmNotifier.perform(@alarm.id)
      a_request(:post, FootprintsAlarmNotifier.ws_uri).with(
        :headers => { "SOAPAction" => "http://10.50.1.196/MRWebServices#MRWebServices__createIssue" }
      ).should have_been_made
    end

    it "sets the content type" do
      FootprintsAlarmNotifier.perform(@alarm.id)
      a_request(:post, FootprintsAlarmNotifier.ws_uri).with(
        :headers => { "Content-Type" => "text/xml; charset=utf-8" }
      ).should have_been_made
    end

    it "stores the footprints ticket id in the alarm" do
      FootprintsAlarmNotifier.perform(@alarm.id)
      @alarm.reload.footprints_issue_id.should == 12
    end
  end
end
