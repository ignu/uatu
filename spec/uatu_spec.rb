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

  end

end

describe Uatu do
  describe "creating a model" do
    it "logs the create details" do
      Ninja.new.save
    end
  end
end
