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

  context "with valid current_user strategy" do

    let(:ninja) { Ninja.new }

    before do
      Uatu.configure do |config|
       config.user_strategy { :rodimus_prime }
      end
      ninja.stubs(:id).returns(3)
    end

    describe "creating a model" do
      it "logs the create details" do
        ninja.expects(:persisted?).returns(false).at_least(1)
        Uatu::Logger.expects(:create).with({:user        => :rodimus_prime,
                                            :action      => "created",
                                            :entity_type => "Ninja",
                                            :entity_id   => 3 })
        ninja.save
      end

    end

    describe "updating a model" do
      before do
        ninja.expects(:persisted?).returns(true).at_least(1)
        ninja.weapon = "sword"
        ninja.save
      end

      it "logs the update details" do
        Uatu::Logger.expects(:create).with({:user        => :rodimus_prime,
                                            :action      => "updated",
                                            :entity_type => "Ninja",
                                            :entity_id   => 3 })

        ninja.weapon = "pen"
        ninja.save
      end
    end
  end

  describe Uatu::Logger, ".create" do
    it "creates a new AuditLog with the given params" do
      audit_log = {}
      AuditLog.expects(:new).with(:these_params).returns(audit_log)
      audit_log.expects(:save!)
      Uatu::Logger.create(:these_params)
    end
  end
end
