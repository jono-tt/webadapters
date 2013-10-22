require 'spec_helper'
require 'script_runner'

describe "Evaluation security" do
  it "can't call system from the script" do
    script = "system('ls') \n result 1"
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should raise_error(SecurityError)
  end

  it "can't call ` from the script" do
    script = "`ls` \n result 1"
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should raise_error(SecurityError)
  end

  it "can't modify environment" do
    script = "class Environment; def test123; end; end; test123\n result 1"
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should raise_error(NameError)
  end

  it "can't use syscall" do
    script = %{syscall(25)\n result 1}
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should raise_error(SecurityError)
  end

  it "can't eval new code" do
    script = %{eval("1+1")\n result 1}
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should raise_error(SecurityError)
  end

  it "can make get requests" do
    WebMock.allow_net_connect!
    script = %{get "http://www.google.com"}
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should_not raise_error(SecurityError)
    WebMock.disable_net_connect!
  end

  it "can make post requests" do
    WebMock.allow_net_connect!
    script = %{query = { s: "cats" }; post "http://www.google.com", query}
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should_not raise_error(SecurityError)
    WebMock.disable_net_connect!
  end

  it "can use expand_path freely" do
    script = 'File.expand_path(File.expand_path("a", "b"), "a"); result 1'
    lambda do
      ScriptRunner.run(script, :remote_session => RemoteSession.get(nil))
    end.should_not raise_error(SecurityError)
  end

end

