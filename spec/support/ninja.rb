require 'spec_helper'

class Ninja
  extend ActiveModel::Callbacks
  define_model_callbacks :create

  include Uatu

  def name=(value)
    @name=value
  end

  def name
    @name
  end

  def create
    _run_create_callbacks
  end

  def save
    create
  end
end
