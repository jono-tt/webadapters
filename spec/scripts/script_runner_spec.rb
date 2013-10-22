require 'spec_helper'
require 'script_runner'

describe "Script Runner" do

  it "can put hash into result block" do
    script = "result 'test' do \n
      {:test => 'key'}
    end"
    response = ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    response[:response].should == ["test", {:test=>"key"}]   
  end

  it "can put string into result block" do
    script = "result 'test' do \n
      'spec'
    end"
    response = ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    response[:response].should == ["test", "spec"]   
  end

  it "alerts when you use more then once 'result' in script" do
    script = "result 'test1'  \n
    result 'test2' "
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should raise_error(ArgumentError)
  end

end

