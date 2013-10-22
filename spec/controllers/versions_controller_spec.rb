require 'spec_helper'

describe VersionsController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET show for the latest version" do
    before :each do
      @api_method = FactoryGirl.create(:api_method, :script => "Original version")
      2.times do |count|
        @api_method.script = "script version #{count + 1}"
        @api_method.save_version(:user => @user, :message => "change #{count + 1}")
      end
      @site = @api_method.site
    end

    def do_action
      get :show, :site_id => @site.id, :api_method_id => @api_method.id, :id => :latest
    end

    it "is succesful" do
      do_action
      response.should be_success
    end

    it "assigns the latest version of the script" do
      do_action
      assigns[:version].should == @api_method.script_versions.first
    end

    it "assigns a list of the versions" do
      do_action
      assigns[:versions].should == [["2: change 2", 2], ["1: change 1", 1]]
    end

    it "assigns a list of comparable versions" do
      do_action
      assigns[:compare_versions].should == [["--none--", nil], ["1: change 1", 1]]
    end

    it "truncates long messages" do
      message = "This is a very very long message that should get truncated"
      @api_method.save_version(:user => @user, :message => message)
      do_action
      assigns[:versions].should == [["3: This is a very very long...", 3], ["2: change 2", 2], ["1: change 1", 1]]
    end

    it "truncates at newlines" do
      message = "Last commit\nThis is a very very long message that should get truncated"
      @api_method.save_version(:user => @user, :message => message)
      do_action
      assigns[:versions].should == [["3: Last commit...", 3], ["2: change 2", 2], ["1: change 1", 1]]
    end
  end

  describe "GET show for an earlier version" do
    before :each do
      @api_method = FactoryGirl.create(:api_method, :script => "Original version")
      2.times do |count|
        @api_method.script = "script version #{count + 1}"
        @api_method.save_version(:user => @user, :message => "change #{count + 1}")
      end
      @site = @api_method.site
    end

    def do_action
      get :show, :site_id => @site.id, :api_method_id => @api_method.id, :id => 2
    end

    it "is succesful" do
      do_action
      response.should be_success
    end

    it "assigns the earlier version of the script" do
      do_action
      assigns[:version].should == @api_method.script_versions.find_by_version(2)
    end

    it "assigns a list of the versions" do
      do_action
      assigns[:versions].should == [["2: change 2", 2], ["1: change 1", 1]]
    end
  end

  describe "GET show with a compare id" do
    before :each do
      @api_method = FactoryGirl.create(:api_method, :script => "Original version")
      2.times do |count|
        @api_method.script = "script version #{count + 1}"
        @api_method.save_version(:user => @user, :message => "change #{count + 1}")
      end
      @site = @api_method.site
    end

    def do_action
      get :show, :site_id => @site.id, :api_method_id => @api_method.id, :id => 2, :compare_id => 1
    end

    it "is successful" do
      do_action
      response.should be_success
    end

    it "assigns a list of the versions" do
      do_action
      assigns[:versions].should == [["2: change 2", 2], ["1: change 1", 1]]
    end

    it "assigns the version of the script" do
      do_action
      assigns[:version].should == @api_method.script_versions.find_by_version(2)
    end

    it "assigns the comparison version of the script" do
      do_action
      assigns[:compare_version].should == @api_method.script_versions.find_by_version(1)
    end

    it "assigns the diff" do
      do_action
      assigns[:diff].should == "script version <del class=\"differ\">2</del><ins class=\"differ\">1</ins>"
    end
  end


  describe "PUT restore" do
    before :each do
      @api_method = FactoryGirl.create(:api_method)
      @site = @api_method.site
      2.times do |count|
        @api_method.script = "script version #{count + 1}"
        @api_method.save_version(:user => @user, :message => "change #{count + 1}")
      end
      @version = @api_method.script_versions.last
    end

    def do_action
      put :restore, :site_id => @site.id, :api_method_id => @api_method.id, :id => @version.id
    end

    it "redirects to the api method page" do
      do_action
      response.should redirect_to(site_api_method_url(@site, @api_method))
    end

    it "creates a new script version" do
      lambda { do_action }.should change(ScriptVersion, :count).by(1)
    end

    it "sets the commit message" do
      do_action
      ScriptVersion.first.message.should == "Restored version #{@version.version}\n\n#{@version.message}"
    end
    
    it "sets the user who restored the version" do
      do_action
      ScriptVersion.first.user.should == @user
    end

    it "sets the script to the restored version" do
      do_action
      @api_method.reload.script.should == @version.script
    end
  end
end
