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

  def save
    _log_create
  end
end
