# frozen_string_literal: true

require_relative 'item'

class SwapDie < Item
  NUMBERS = [0]
  @@description = "\nSwap out one of the Dealer\'s dice for this."
  @@type = :swap_die

  class << self
    def type
      @@type
    end

    def description
      @description + @@description
    end

    def use
      replacement = pick_die("Replace which die?")

      return if replacement == :skip

      @destroy = true
      Dealer.send("#{replacement}=", self::NUMBERS) 
    end
  end
end

