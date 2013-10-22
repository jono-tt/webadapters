require 'spec_helper'

describe ApiMethod do

  before :each do
    @api_method = FactoryGirl.create(:api_method) 
  end

  describe "validation" do

    it "is not valid empty" do
      ApiMethod.new.should_not be_valid
    end

    describe "name" do
      it "is not valid with spaces in the name" do
        api_method = FactoryGirl.build(:api_method, :name => "name with spaces")
        api_method.should_not be_valid
        api_method.errors[:name].should_not be_blank
      end

      it "is not valid with ? in the name" do
        api_method = FactoryGirl.build(:api_method, :name => "name?")
        api_method.should_not be_valid
        api_method.errors[:name].should_not be_blank
      end

      it "cannot be blank" do
        api_method = FactoryGirl.build(:api_method, :name => "")
        api_method.should_not be_valid
        api_method.errors[:name].should_not be_blank
      end
    end

    it "is valid out of default factory" do
      FactoryGirl.build(:api_method).should be_valid
    end

  end

  describe "draft" do

    it "saves draft" do
      @api_method.save_draft("test")
      @api_method.should be_valid
      @api_method.reload
      @api_method.draft.should == "test"
    end

    it "don't save draft if script is same as draft" do
      @api_method.script = "test"
      @api_method.save_draft("test   ")
      @api_method.script.should == "test"
      @api_method.draft?.should be_false
      @api_method.draft.should be_nil
    end

    it "compares draft and script without \\r inside" do
      @api_method.script = "test\r\ntest"
      @api_method.save_draft("test\ntest")
      @api_method.should_not be_draft
    end

    it "clears draft" do
      @api_method.draft = "la la"
      @api_method.clear_draft
      @api_method.draft.should be_nil
    end

  end

  describe "save_version" do
    before :each do
      @api_method = FactoryGirl.create(:api_method)
      @user = FactoryGirl.create(:user)
    end

    it "updates the script" do
      new_script = "new script"
      @api_method.script = new_script
      @api_method.save_version(:user => @user, :message => "Checking the script")
      @api_method.reload.script.should == new_script
    end

    it "creates a new version of the script" do
      @api_method.script = "new script"
      lambda do
        @api_method.save_version(:user => @user, :message => "Creating a version")
      end.should change(ScriptVersion, :count).by(1)
    end

    it "stores the user who created the new version" do
      @api_method.script = "new script"
      @api_method.save_version(:user => @user, :message => "Checking the user")
      ScriptVersion.last.user.should == @user
    end

    it "saves the comment with the new version" do
      @api_method.script = "new script"
      message = "Description of change"
      @api_method.save_version(:user => @user, :message => message)
      ScriptVersion.last.message.should == message
    end
  end
end
