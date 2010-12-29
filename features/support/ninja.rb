class Ninja
  include Mongoid::Document
  include Uatu
  after_create :_log_create
  field :name
end
