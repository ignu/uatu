class Clan
  include Mongoid::Document
  include Uatu
  field :name
  references_many :ninjas
end

class Ninja
  include Mongoid::Document
  include Uatu
  field :name
  field :weapon
end

class Vehicle
  include Mongoid::Document
  include Uatu
  field :name
end

