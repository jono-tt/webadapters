require 'spec_helper'

describe Script do
  describe "running a successful script" do
    before :each do
      @script_content = "result 'it works'"
      @script = Script.new(@script_content)
      @remote_session = RemoteSession.get(nil)
    end

    it "calls ScriptRunner" do
      params = {:remote_session => @remote_session}
      ScriptRunner.should_receive(:run).with(@script_content, params)
      @script.run(params)
    end

    it "is successful" do
      @script.run(:remote_session => @remote_session)
      @script.should be_successful
    end

    it "returns the result" do
      @script.run(:remote_session => @remote_session)
      @script.result.should == "it works"
    end
  end

  describe "with a script with a syntax error" do
    before :each do
      @script_content = "end"
      @script = Script.new(@script_content)
      @remote_session = RemoteSession.get(nil)
    end

    it "should not raise an error" do
      expect { @script.run(:remote_session => @remote_session) }.to_not raise_error
    end

    it "is not successful?" do
      @script.run(:remote_session => @remote_session)
      @script.should_not be_successful
    end

    it "sets the error message" do
      @script.run(:remote_session => @remote_session)
      # The exact error message depends on whether or not $SAFE=1 is enabled
      @script.error.should =~ /Syntax error on line 1: unexpected keyword_end(, expecting $end\n$SAFE=1;end\n           ^)?/
    end

    it "sets the line number" do
      @script.run(:remote_session => @remote_session)
      @script.line.should == 1
    end
  end

  describe "with a script with a semantic error" do
    before :each do
      @script_content = "iweof"
      @script = Script.new(@script_content)
      @remote_session = RemoteSession.get(nil)
    end

    it "should not raise an error" do
      expect { @script.run(:remote_session => @remote_session) }.to_not raise_error
    end

    it "is not successful?" do
      @script.run(:remote_session => @remote_session)
      @script.should_not be_successful
    end

    it "sets the error message" do
      @script.run(:remote_session => @remote_session)
      @script.error.should == "NameError: undefined local variable or method `iweof'"
    end
  end


  describe "with no result" do
    before :each do
      @script_content = "pointless = true"
      @script = Script.new(@script_content)
      @remote_session = RemoteSession.get(nil)
    end

    it "is successful" do
      @script.run(:remote_session => @remote_session)
      @script.should be_successful
    end

    it "sets the result and error to nil" do
      @script.run(:remote_session => @remote_session)
      @script.error.should == nil
      @script.result.should == nil
    end

    it "sets a helpful warning message" do
      @script.run(:remote_session => @remote_session)
      @script.warning.should == "The script produced no output. Did you forget to add 'result' to the end?"
    end
  end
end
