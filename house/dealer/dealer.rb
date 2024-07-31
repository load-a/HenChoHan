# frozen_string_literal: true

require_relative 'constants'
require_relative 'dealer_state'

class Dealer
  extend DealerState

  @die_1 = STANDARD_DIE
  @die_2 = STANDARD_DIE
  @result = [0, 0]
  @round = 1
  @match = 1

  class << self

    attr_reader :match, :round, :par, :result
    attr_accessor :die_1, :die_2

    def dice
      {
        die_1: die_1,
        die_2: die_2
      }
    end

    def roll
      @result = [@die_1.sample, @die_2.sample]
    end

    def next_round
      @round += 1
    end

    def next_match
      @round = 1
      @match += 1
    end
  end
end

