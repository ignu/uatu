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
        ninja.stubs(:id).returns(3)
      end

      it "logs the create details" do
        Uatu::Logger.expects(:create).with({:user => :rodimus_prime,
                                            :type => "Ninja",
                                            :id   => 3 })
        ninja.save
      end

    end
  end

  describe Uatu::Logger, ".create" do
    it "creates a new AuditLog with params" do
      audit_log = AuditLog.new
      audit_log.expects(:save)
      ninja = Ninja.new
      AuditLog.expects(:new).with({:user => :rodimus_prime,
                                            :type => "Ninja",
                                            :id   => ninja.id }).returns(audit_log)
      ninja.save
    end
  end
end
