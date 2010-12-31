require 'spec_helper'

class Ninja
  extend ActiveModel::Callbacks
  define_model_callbacks :create, :update

  include Uatu

  def weapon=(value)
    @weapon=value
  end

  def weapon
    @weapon
  end

  def name=(value)
    @name=value
  end

  def name
    @name
  end

  def update
    _run_update_callbacks
  end

  def create
    _run_create_callbacks
  end

  def save
    create unless self.persisted?
    update if self.persisted?
  end
end
