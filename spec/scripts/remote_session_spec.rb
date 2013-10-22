require 'spec_helper'
require 'script_runner'

describe "Passing cookies to the origin site" do
  before :each do
    @domain = "www.velti.com"
    @different_domain = "migcan.com"

    @exact_domain_cookie = "foo=bar"
    set_exact_domain_cookie = "#{@exact_domain_cookie}; Domain=#{@domain}; Path=/"

    @super_domain_cookie = "super=cookie"
    set_super_domain_cookie = "#{@super_domain_cookie}; Domain=#{@domain.sub('www', '')}; Path=/"

    @sub_domain_cookie = "sub=cookie"
    set_sub_domain_cookie = "#{@sub_domain_cookie}; Domain=uk.#{@domain}; Path=/"

    @different_domain_cookie = "different=cookie"
    set_different_domain_cookie = "#{@different_domain_cookie}; Domain=#{@different_domain}; Path=/"

    stub_request(:any, "http://#{@domain}/").to_return(
      :body => "", 
      :status => 200, 
      :headers => { 
        "Content-Type" => "text/html; charset=UTF-8", 
        "Set-Cookie" => [set_exact_domain_cookie, set_super_domain_cookie, set_sub_domain_cookie, set_different_domain_cookie] 
      }
    )

    stub_request(:get, "http://#{@different_domain}/").to_return(
      :body => "", 
      :status => 200, 
      :headers => { 
        "Content-Type" => "text/html; charset=UTF-8", 
        "Set-Cookie" => [set_exact_domain_cookie, set_super_domain_cookie, set_sub_domain_cookie, set_different_domain_cookie] 
      }
    )

    @script = %{get "http://#{@domain}/"}
    @different_script = %{get "http://#{@different_domain}/"}

    @remote_session = RemoteSession.new(98)
  end

  it "sends cookies for the origin site and any super domains" do
    # Run the script twice - once to set the cookies and once when they get passed back
    2.times { ScriptRunner.run(@script, :remote_session => @remote_session ) }

    a_request(:get, "http://#{@domain}").with do |req| 
      cookie_header = req.headers["Cookie"] || []
      cookie_header.include?(@exact_domain_cookie) && cookie_header.include?(@super_domain_cookie)
    end.should have_been_made
  end

  it "doesn't send cookies for sub-domains" do
    # Run the script twice - once to set the cookies and once when they get passed back
    2.times { ScriptRunner.run(@script, :remote_session => @remote_session ) }

    a_request(:get, "http://#{@domain}").with do |req| 
      cookie_header = req.headers["Cookie"] || []
      cookie_header.include?(@sub_domain_cookie)
    end.should_not have_been_made
  end

  it "doesn't send cookies for different domains" do
    # Run the script twice - once to set the cookies and once when they get passed back
    2.times { ScriptRunner.run(@script, :remote_session => @remote_session ) }

    a_request(:get, "http://#{@domain}").with do |req| 
      cookie_header = req.headers["Cookie"] || []
      cookie_header.include?(@different_domain_cookie)
    end.should_not have_been_made
  end

  it "sends cookies to different domains" do
    # Run the script twice - once to set the cookies and once when they get passed back
    2.times { ScriptRunner.run(@different_script, :remote_session => @remote_session ) }

    a_request(:get, "http://#{@different_domain}").with do |req| 
      cookie_header = req.headers["Cookie"] || []
      cookie_header.include?(@different_domain_cookie)
    end.should have_been_made
  end

  it "sends cookies for post requests" do
    post_script = %{post "http://www.velti.com"}

    # Run the script twice - once to set the cookies and once when they get passed back
    2.times { ScriptRunner.run(post_script, :remote_session => @remote_session ) }

    a_request(:post, "http://#{@domain}").with do |req| 
      cookie_header = req.headers["Cookie"] || []
      cookie_header.include?(@exact_domain_cookie) && cookie_header.include?(@super_domain_cookie)
    end.should have_been_made
  end
end
