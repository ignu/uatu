module Uatu
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
    end
  end
end
