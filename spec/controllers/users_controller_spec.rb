require 'spec_helper'

describe UsersController do
  render_views
  
  before :each do
    @user = FactoryGirl.create(:user) # for now
    sign_in @user
  end

  describe "routes" do
    it "is working" do
      { :get => "/users" }.should be_routable
      { :get => "/users/5/edit" }.should be_routable
      { :post => "/users" }.should be_routable
      { :put => "/users/5" }.should be_routable
      { :put => "/users/5/disable" }.should be_routable
      { :put => "/users/5/enable" }.should be_routable
    end
  end

  describe "list actions" do

    it "can GET index" do
      get :index
      response.should be_success
    end

    it "is redirected when trying to GET index unauthenticated" do
      sign_out @user
      get :index
      response.should be_redirect
    end

  end

  describe "creation" do

    it "can GET new" do
      get :new
      response.should be_success
    end

    it "can't create invalid user" do
      lambda do
        post :create, {}
        response.should render_template("new")
        response.should be_success
      end.should_not change(User, :count)
    end

    it "creates user" do
      lambda do
        post :create, :user => FactoryGirl.attributes_for(:user)
        response.should be_redirect
      end.should change(User, :count).by(1)
    end

  end

  describe "editing" do
    it "can GET edit" do
      get :edit, :id => @user.id
      response.should be_success    
    end

    it "can update self" do
      email = @user.email
      put :update, :id => @user.id, :user => { :email => ("new" + email), :password => "", :password_confirmation => "" }
      response.should be_redirect
      @user.reload
      @user.email.should == ("new" + email)
    end

    it "renders 'edit' on invalid update data" do
      put :update, :id => @user.id, :user => { :email => "", :password => "momma!" } 
      response.should render_template("edit")
      response.should be_success
    end
  end

  describe "disable" do
    before :each do
      @different_user = FactoryGirl.create(:user)
    end

    it "disables the user" do
      put :disable, :id => @different_user.id
      @different_user.reload.should be_disabled
    end

    it "redirects to the user index" do
      put :disable, :id => @different_user.id
      response.should redirect_to(users_url)
    end
  end

  describe "enable" do
    before :each do
      @different_user = FactoryGirl.create(:user, :enabled => true)
    end

    it "enables the user" do
      put :enable, :id => @different_user
      @different_user.reload.should be_enabled
    end

    it "redirects to the user index" do
      put :enable, :id => @different_user
      response.should redirect_to(users_url)
    end
  end

end
