require 'spec_helper'

describe Uatu do
  describe "configure" do
    before do
      Uatu.configure do |config|
       config.user_strategy { :rodimus_prime }
      end
    end

    it "takes a block that returns the current user" do
      Uatu.current_user.should == :rodimus_prime
    end

  end

  describe "creating a model" do
    context "with valid current_user strategy" do
      let(:ninja) { Ninja.new }

      before do
        Uatu.configure do |config|
         config.user_strategy { :rodimus_prime }
        end
      end

      it "logs the create details" do
        Uatu::Logger.expects(:create).with({:user => :rodimus_prime})
        ninja.save
      end
    end
  end
end
