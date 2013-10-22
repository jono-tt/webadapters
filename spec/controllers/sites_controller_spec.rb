require 'spec_helper'

describe SitesController do

  before(:each) do
    @site = FactoryGirl.create(:site)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "routes" do
    it "are routable" do
      { :get => "/sites" }.should be_routable
      { :get => "/sites/677" }.should be_routable
      { :post => "/sites" }.should be_routable
      { :put => "/sites/5" }.should be_routable
      { :delete => "/sites/44" }.should be_routable
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get "show", :id => @site.id
      response.should be_success
    end

    it "breaks on wrong id" do
      lambda do
        get "show", :id => (@site.id + 1)
      end.should raise_error
    end
  end

  describe "GET 'new'" do

    it "return http success" do
      get "new"
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "creates site" do
      lambda do
        post "create", site: { name: "Test" }
        response.should be_redirect
      end.should change(Site, :count).by(1)
    end

    it "don't create site with invalid data" do
      lambda do
        post "create", site: {}
        response.status.should == 200
      end.should change(Site, :count).by(0)
    end

  end

  describe "GET 'edit'" do
    it "renders edit page" do
      get "edit", :id => @site.id
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "updates site name" do
      lambda do
        put "update", :id => @site.id, :site => { :name => "kubus!" }
        response.should be_redirect
      end.should_not change(Site, :count)
    end

    it "should not allow wrong values" do
      put "update", :id => @site.id, :site => { :name => "" }
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    it "removes site" do
      lambda do
        delete "destroy", :id => @site
        response.should be_redirect
      end.should change(Site, :count).by(-1)
    end
  end

  describe "Archiving" do
    it "routes to archived, archive and unarchive" do
      { :get => "/sites/archived" }.should be_routable
      { :put => "/sites/54/unarchive" }.should be_routable
      { :put => "/sites/13/archive" }.should be_routable
    end

    it "can view archived sites" do
      get :archived
      response.should be_success
    end

    it "can archive site" do
      site = FactoryGirl.create(:site)
      site.should_not be_archived
      put :archive, :id => site.id
      site.reload
      site.should be_archived
    end

    it "can unarchive site" do
      site = FactoryGirl.create(:site, :archived => true)
      site.should be_archived
      put :unarchive, :id => site.id
      site.reload
      site.should_not be_archived
    end
  end

end
