module Uatu
  def self.included(document_class)
    document_class.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def _log_create
      Uatu::Logger.create({:user        => Uatu.current_user,
                           :entity_type => self.class.name,
                           :entity_id   => self.id })
    end
  end

  class << self
    def current_user
      @block.call
    end

    def user_strategy(&block)
      @block=block
    end

    def configure (&block)
      self.instance_eval(&block)
    end
  end

  module Logger
    def self.create(params)
      audit_log = AuditLog.new(params)
      audit_log.save!
    end
  end
end

class AuditLog
  include Mongoid::Document

  field :user
  field :entity_type
  field :entity_id

end
