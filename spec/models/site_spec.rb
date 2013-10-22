require 'spec_helper'

describe Site do
  describe "valid" do
    
    it "is not be valid empty" do
      Site.new.should_not be_valid
    end

    it "is valid with name" do
      Site.new(:name => "test").should be_valid
    end

    it "is able to save Site to db" do
      site = FactoryGirl.build(:site)
      site.save.should be_true
    end

  end
end
