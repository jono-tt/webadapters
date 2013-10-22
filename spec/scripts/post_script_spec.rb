require 'spec_helper'
require 'script_runner'

describe "Post script" do
  it "sends data to the origin site" do
    post_body = { :username => "someone", :password => "password" }
    stub_request(:post, "http://velti.com/").with(:body => post_body)

    script = %{post "http://velti.com/", #{post_body}}
    ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))

    a_request(:post, "http://velti.com/").with(:body => post_body).should have_been_made
  end

  it "works when there is no data" do
    stub_request(:post, "http://velti.com/")

    script = %{post "http://velti.com/"}
    ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))

    a_request(:post, "http://velti.com/").with(:body => {}).should have_been_made
  end

  it "sends headers with post request" do
    headers = { "Content-Type" => "application/json" }
    stub_request(:post, "http://velti.com/")
    script = %{post "http://velti.com/", {}, #{headers}}
    ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))

    a_request(:post, "http://velti.com/").with(:headers => headers).should have_been_made
  end

end
