module Uatu

  def self.included(document_class)
    document_class.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def _log_create
      Uatu::Logger.create({:user => :rodimus_prime,
                           :type => self.class.name,
                           :id   => self.id })
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
      AuditLog.new(params).save
    end
  end
end

class AuditLog
  def new(params)
  end

  def save
  end
end
