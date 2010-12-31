class Ninja
  include Mongoid::Document
  include Uatu
  field :name
  field :weapon
end
