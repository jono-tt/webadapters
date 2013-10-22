require 'spec_helper'
require 'script_runner'

describe "Debugging a script" do
  it "can use splats as args" do
    script = "debug 1, 2, 3 \n result 1"
    response = ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    response[:debug].should == ["1","2","3"]
  end

  it "can use debug function" do
    script = "debug 'test' \n result 1"
    response = ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    response[:debug].should == ["\"test\""]
  end
end

