require 'spec_helper'

class NinjaTurtle
  extend ActiveModel::Callbacks
  include ActiveModel::Dirty
  define_model_callbacks :create, :update
  include Uatu
  watched_by :ninja
end

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

  describe ".watched_by" do

    it "adds the class symbol to the watched classes" do
      NinjaTurtle.watching_classes.first.should == :ninja
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

    context "when creating a model" do
      it "logs the create details" do
        ninja.stubs(:persisted?).returns(false)
        Uatu::Logger.expects(:create).with({:user        => :rodimus_prime,
                                            :action      => "created",
                                            :message     => "Created",
                                            :entity_type => "Ninja",
                                            :entity_id   => 3 })
        ninja.save
      end

    end

    context "when updating a model" do

      before do
        ninja.stubs(:persisted?).returns(true)
        ninja.weapon = "sword"
        ninja.name = "John"
        ninja.save
      end

      it "logs the update details" do
        new_message = 'Changed "name" from "John" to "Mary" and "weapon" from "sword" to "pen"'
        Uatu::Logger.expects(:create).with({:user        => :rodimus_prime,
                                            :action      => "updated",
                                            :message     => new_message,
                                            :entity_type => "Ninja",
                                            :entity_id   => 3 })

        ninja.weapon = "pen"
        ninja.name = "Mary"
        ninja.save
      end

      it "logs updates to associated entities" do
        ninja.name = "John"
        ninja.save
        clan = Clan.new
        clan.save
        new_message = 'Added Ninja "John"'
        Uatu::Logger.expects(:create).with({:user        => :rodimus_prime,
                                            :action      => "added",
                                            :message     => new_message,
                                            :entity_type => "Clan",
                                            :entity_id   => clan.id })

        ninja.to_s.should == "John"
        clan.ninjas << ninja

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
