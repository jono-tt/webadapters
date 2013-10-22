require 'spec_helper'

describe User do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it "is valid from factory" do
    FactoryGirl.build(:user).should be_kind_of(User)
    FactoryGirl.build(:user).should be_valid
  end

  describe "password_confirmation" do
    it "is required when creating a new user" do
      user_attributes = FactoryGirl.attributes_for(:user)
      user_attributes.delete(:password_confirmation)
      user = User.new(user_attributes)
      user.should_not be_valid
      user.errors[:password_confirmation].should_not be_blank
    end

    it "is required when changing the password" do
      FactoryGirl.create(:user)
      # We need to reload the user to git rid of the confirmation field
      # set by FactoryGirl
      user = User.last
      user.password = "new_password"
      user.should_not be_valid
      user.errors[:password_confirmation].should_not be_blank
    end

    it "is not required when changing the email" do
      FactoryGirl.create(:user)
      # We need to reload the user to git rid of the confirmation field
      # set by FactoryGirl
      user = User.last
      user.email = "new_" + user.email
      user.should be_valid
    end
  end

  it "can be disabled" do
    @user.disable!
    @user.should be_disabled
  end

  it "is enabled by default" do
    @user.should be_enabled
  end

  it "is not finding disabled users" do
    disabled_user = FactoryGirl.create(:user, :enabled => false)
    User.find_for_authentication(:email => disabled_user.email).should be_nil
  end

end
