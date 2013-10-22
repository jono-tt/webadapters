require 'spec_helper'
require 'script_runner'

describe "Session Store" do

  it "can store value and restore it later" do
    remote_session = RemoteSession.get(nil)
    script = "store(:test, 'needed value') \n
      result 1
    "
    ScriptRunner.run(script, :remote_session => remote_session)
    retriving_script = "test = load(:test) \n
      result test
    "
    result = ScriptRunner.run(retriving_script, :remote_session => remote_session)
    result[:response].should == "needed value"
  end

    it "can cant access data within other session" do
    script = "store(:test, 'needed value') \n
      result 1
    "
    ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    retriving_script = "test = load(:test) \n
      result test
    "
    result = ScriptRunner.run(retriving_script, :remote_session => RemoteSession.get(nil))
    result[:response].should == nil
  end

end

