require 'spec_helper'
require 'script_runner'

describe "Default script" do
  before :each do
    velti_fixture_file = File.join(Rails.root, "spec", "fixtures", "www", "velti.com")
    velti = File.read(velti_fixture_file)
    stub_request(:get, "http://velti.com/").to_return(:body => velti, :status => 200, :headers => { 'Content-Type' => 'text/html; charset=UTF-8'})
    default_script_file = File.join(Rails.root, "config", "default_script")
    @script = File.read(default_script_file)
  end

  it "returns the page title as the result" do
    response = ScriptRunner.run(@script, :remote_session => RemoteSession.get(nil))[:response]
    response.should == "Velti | Velti, Mobile Marketing and Mobile Advertising"
  end
end
