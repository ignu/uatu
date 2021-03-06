module Uatu

  def self.included(document_class)
    document_class.instance_eval do
      extend ClassMethods
    end
    document_class.class_eval do
      include InstanceMethods
    end
    document_class.send(:after_create,  :_log_create)
    document_class.send(:before_update, :_store_changes)
    document_class.send(:after_update,  :_log_update)
  end

  module ClassMethods
    def watching_classes
      @watching_classes
    end

    def watched_by(klass)
      @watching_classes ||= []
      @watching_classes << klass
    end
  end

  module InstanceMethods

    def _store_changes
      updates = "Changed"
      prefix = ""
      self.changes.each do |change|
        prefix = "and " unless updates == "Changed"
        updates = %{#{updates} #{prefix}"#{change[0]}" from "#{change[1][0]}" to "#{change[1][1]}"}
      end
      @_changes = updates
    end

    def _log_update
      Uatu::Logger.create({:user        => Uatu.current_user,
                           :action      => "updated",
                           :message     => @_changes,
                           :entity_type => self.class.name,
                           :entity_id   => self.id })
    end

    def _log_create
      Uatu::Logger.create({:user        => Uatu.current_user,
                           :action      => "created",
                           :message     => "Created",
                           :entity_type => self.class.name,
                           :entity_id   => self.id })

      self.class.watching_classes.each do |klass_name|
        klass_name = klass_name.to_s
        message = "Added #{self.class.name.capitalize} \"#{self.to_s}\""
        Uatu::Logger.create({:user        => Uatu.current_user,
                             :action      => "added",
                             :message     => message,
                             :entity_type => klass_name.capitalize,
                             :entity_id   => self.send(klass_name).id })
      end
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
  field :action
  field :message

  def self.for_user(user)
    self.where :user => user
  end

  def self.for_entity(entity)
    self.where(:entity_type => entity.class.name, :entity_id => entity._id).to_a
  end

  def to_s
    "#{user} | #{action} | #{entity_type} | #{message} | #{entity_id}"
  end

  def self.print_collection(collection)
    collection.to_a.each do |log|
      p log.to_s
    end
  end

  def self.print_all
    print_collection self.all
  end
end
