# frozen_string_literal: true

require_relative 'item'

class SwapDie < Item
  NUMBERS = [0]
  @@description = "\nSwap out one of the Dealer\'s dice for this."
  @@type = :swap_die
  @@uses = 1
  @@price_percent = 1.25

  class << self
    @level ||= 1

    def type
      @@type
    end

    def price
      @@price_percent * Scorer.par
    end

    def uses
      @@uses
    end

    def uses_left
      @uses_left ||= uses
    end

    def description
      @description + @@description
    end

    def use
      replacement = pick_die("Replace which die?")

      return if replacement == :skip

      Dealer.send("#{replacement}=", self::NUMBERS) 
      
      super
    end
  end
end

