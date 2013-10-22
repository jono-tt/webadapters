require 'spec_helper'

describe AlarmsController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns the alarms" do
      3.times { FactoryGirl.create(:alarm) }
      get 'index'
      assigns[:alarms].should == Alarm.all
    end

    describe "with api_method id" do
      it "assigns the alarms belonging to that api_method" do
        api_method = FactoryGirl.create(:api_method)
        3.times { FactoryGirl.create(:alarm, :api_method => api_method) }
        3.times { FactoryGirl.create(:alarm) }
        get 'index', :site_id => api_method.site.id, :api_method_id => api_method.id
        assigns[:alarms].map(&:id).should == api_method.alarms.map(&:id)
      end
    end
  end

  describe "GET 'show'" do
    before :each do
      @alarm = FactoryGirl.create(:alarm)
    end

    it "is successful" do
      get :show, :id => @alarm.id
      response.should be_success
    end

    it "assigns the alarm" do
      get :show, :id => @alarm.id
      assigns[:alarm].should == @alarm
    end

    it "assigns the site" do
      get :show, :id => @alarm.id
      assigns[:site].should == @alarm.site
    end

    it "assigns the api_method" do
      get :show, :id => @alarm.id
      assigns[:api_method].should == @alarm.api_method
    end
  end
end
