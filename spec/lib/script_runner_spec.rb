require 'spec_helper'
require 'script_runner'

describe ScriptRunner do
  it "raises an argument error if the remote session is not passed in" do
    expect do
      ScriptRunner.run("true")
    end.to raise_error(ArgumentError)
  end

  it "registeres stats" do
    expect do
      result = ScriptRunner.run("result true", :remote_session => RemoteSession.get(nil))
      result.keys.should include(:stats)
    end.to_not raise_error
  end

  it "is able to pass to result hash" do
    expect do
      ScriptRunner.run("result({}){{}}", :remote_session => RemoteSession.get(nil))
    end.to_not raise_error    
  end

  it "result content can be nil" do
    expect do
      ScriptRunner.run("result(nil){{}}", :remote_session => RemoteSession.get(nil))
    end.to_not raise_error    
  end

end
