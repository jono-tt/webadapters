require 'spec_helper'

describe Stats do

  before(:each) do
    @stats = Stats.new("test") # should be api method id! but in tests it doesn't matter!
  end

  it "can store 25 most recent time records" do
    1.upto(100){|i| @stats.store(i) }
    @stats.times.length.should == 25
  end

  it "returns average of last 25 times" do
    1.upto(25){|i| @stats.store(i) }
    @stats.average_time.should == 13.0
  end

  it "should retunr 0.0 avg time for not existing key" do
    stats = Stats.new("dont_exists")
    stats.average_time.should == nil
  end

end
