require 'spec_helper'
require 'script_runner'

describe "Calling the script with params" do
  it "can access the params" do
    params = {:a => 1, :b => 2}
    script = "result params"
    response = ScriptRunner.run(script, :remote_session => RemoteSession.get(nil), :params => params)
    response[:response].should == params
  end
end
