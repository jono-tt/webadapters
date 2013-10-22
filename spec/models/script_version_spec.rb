require 'spec_helper'

describe ScriptVersion do
  describe "version number" do
    before :each do
      @old_api_method = FactoryGirl.create(:api_method)
      # Create a script version for a different api method
      FactoryGirl.create(:script_version, :api_method => @old_api_method)

      @new_api_method = FactoryGirl.create(:api_method)
    end

    it "is set to 1 for the first version for an Api Method" do
      @script_version = FactoryGirl.create(:script_version, :api_method => @new_api_method)
      @script_version.reload.version.should == 1
    end

    it "is incremented when new versions are saved for an Api Method" do
      FactoryGirl.create(:script_version, :api_method => @new_api_method)
      @script_version = FactoryGirl.create(:script_version, :api_method => @new_api_method)
      @script_version.reload.version.should == 2

      @script_version = FactoryGirl.create(:script_version, :api_method => @new_api_method)
      @script_version.reload.version.should == 3
    end
  end


  describe "compare_with" do
    before :each do
      @api_method = FactoryGirl.create(:api_method)
      @script_version = FactoryGirl.create(:script_version, :api_method => @api_method, :script => "script 1")
      @other_script_version = FactoryGirl.create(:script_version, :api_method => @api_method, :script => "script 2")
    end

    it "returns the result of Differ.diff_by_word" do
      diff = @script_version.compare_with(@other_script_version)
      diff.should == Differ.diff_by_word(@script_version.script, @other_script_version.script)
    end
  end

  describe "current?" do
    before :each do
      @api_method = FactoryGirl.create(:api_method)
      @earlier = FactoryGirl.create(:script_version, :api_method => @api_method, :script => "script 1")
      @latest = FactoryGirl.create(:script_version, :api_method => @api_method, :script => "script 2")
    end

    it "is true when the script is the latest version" do
      @latest.should be_current
    end

    it "is false when the script is an earlier version" do
      @earlier.should_not be_current
    end
  end

  describe "restore!" do
    before :each do
      @user = FactoryGirl.create(:user)
      @api_method = FactoryGirl.create(:api_method)
      @v1 = FactoryGirl.create(:script_version, :api_method => @api_method, :script => "script 1")
      @v2 = FactoryGirl.create(:script_version, :api_method => @api_method, :script => "script 2")
    end

    it "creates a new script version for the api method" do
      count = @api_method.script_versions.count
      @v2.restore!(:user => @user)
      @api_method.script_versions.count.should == count + 1
    end

    it "sets the commit message for the new version" do
      @v2.restore!(:user => @user)
      @api_method.script_versions.first.message.should == "Restored version #{@v2.version}\n\n#{@v2.message}"
    end

    it "sets the user for the new version" do
      @v2.restore!(:user => @user)
      @api_method.script_versions.first.user.should == @user
    end

    it "sets the api method's script" do
      @v2.restore!(:user => @user)
      @api_method.reload.script.should == @v2.script
    end
  end

end
