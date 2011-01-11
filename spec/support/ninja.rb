require 'spec_helper'

class Clan
  extend ActiveModel::Callbacks
  include ActiveModel::Dirty

  define_attribute_methods [:name]
  define_model_callbacks :create, :update

  include Uatu

  def clan=(value)
  end

  def clan
  end

  def ninjas=(value)
    @ninjas=value
  end

  def ninjas
    @ninjas
  end

end

class Ninja
  extend ActiveModel::Callbacks
  include ActiveModel::Dirty
  define_attribute_methods [:name, :weapon]
  define_model_callbacks :create, :update

  include Uatu
  watched_by :clan

  def clan=(value)
  end

  def clan
  end

  def weapon=(value)
    weapon_will_change!
    @weapon=value
  end

  def weapon
    @weapon
  end

  def name=(value)
    name_will_change!
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

  def to_s
    @name
  end
end
