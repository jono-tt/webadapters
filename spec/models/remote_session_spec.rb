require 'spec_helper'

describe RemoteSession do
  before :each do
    @remote_session = RemoteSession.get(nil)
    @key = "some_key"
  end

  describe "set_key" do
    it "appends 'remote_session' and the session ID to all keys" do
      @remote_session.set_key(@key, "some value")
      $redis.keys.should include("remote_session:#{@remote_session.id}:#{@key}")
    end

    it "sets the key/value in redis" do
      @remote_session.set_key(@key, "some value")
      $redis.get("remote_session:#{@remote_session.id}:#{@key}").should == "some value"
    end

    it "sets a TTL on the key" do
      @remote_session.set_key(@key, "some_value")
      $redis.ttl("remote_session:#{@remote_session.id}:#{@key}").should be > -1
    end
  end

  describe "get_key" do
    it "returns the redis key" do
      @remote_session.set_key(@key, "some value")
      @remote_session.get_key(@key).should == "some value"
    end
  end

  describe "storing the last good result" do
    before :each do
      fixture_file = File.join(Rails.root, "spec", "fixtures", "www", "velti.com")
      @page = File.read(fixture_file)
      @url = "http://velti.com/"
      stub_request(:any, @url).to_return(
        :body => @page, :status => 200, 
        :headers => { 'Content-Type' => 'text/html; charset=UTF-8'}
      )
    end

    it "stores the response from 'get' requests, setting the TTL" do
      @remote_session.get(@url)
      $redis.keys.should include("page_history:#{@remote_session.id}:get:#{@url}:current")
      $redis.get("page_history:#{@remote_session.id}:get:#{@url}:current").should == @page
      $redis.ttl("page_history:#{@remote_session.id}:get:#{@url}:current").should be > -1
    end

    it "stores the response from 'post' requests, setting the TTL" do
      @remote_session.post(@url)
      $redis.keys.should include("page_history:#{@remote_session.id}:post:#{@url}:current")
      $redis.get("page_history:#{@remote_session.id}:post:#{@url}:current").should == @page
      $redis.ttl("page_history:#{@remote_session.id}:post:#{@url}:current").should be > -1
    end

    it "moves the response to 'last good' if the request was successful" do
      @remote_session.get(@url)
      @remote_session.success!(1)
      $redis.get("page_history:#{@remote_session.id}:get:#{@url}:last_good").should == @page
      $redis.ttl("page_history:#{@remote_session.id}:get:#{@url}:last_good").should be > -1
    end

    it "stores the 'last good' response for the api method" do
      api_method_id = 1234
      @remote_session.get(@url)
      @remote_session.success!(api_method_id)
      $redis.get("api_method:#{api_method_id}:get:#{@url}:last_good").should == @page
      $redis.ttl("api_method:#{api_method_id}:get:#{@url}:last_good").should be == -1
    end

    it "replaces the 'last good' response for the api method on each call" do
      api_method_id = 1234
      @remote_session.get(@url)
      @remote_session.success!(api_method_id)


      stub_request(:any, @url).to_return(
        :body => "new content", :status => 200, 
        :headers => { 'Content-Type' => 'text/html; charset=UTF-8'}
      )
      new_remote_session = RemoteSession.get(nil)
      new_remote_session.get(@url)
      new_remote_session.success!(api_method_id)

      $redis.get("api_method:#{api_method_id}:get:#{@url}:last_good").should == "new content"
      $redis.ttl("api_method:#{api_method_id}:get:#{@url}:last_good").should be == -1
    end
  end
end
