require 'spec_helper'

class Ninja
  include ActiveModel::Callbacks
  include ActiveModel::Dirty

  include Uatu

  def name=(value)
    @name=value
  end

  def name
    @name
  end

  def after_save
    Uatu::Logger.create({:user=>:rodimus_prime})
  end

  def save
    after_save
  end
end
