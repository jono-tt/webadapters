require 'spec_helper'
require 'script_runner'

describe "Get script" do
  it "sends headers with get request" do
    headers = { "Content-Type" => "application/json" }
    stub_request(:get, "http://velti.com/")

    script = %{get "http://velti.com/", {}, #{headers}}
    ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))

    a_request(:get, "http://velti.com/").with(:headers => headers).should have_been_made
  end
end
