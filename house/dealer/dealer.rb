# frozen_string_literal: true

require_relative 'constants'
require_relative 'dealer_state'
require_relative 'dealer_betting'

class Dealer
  extend DealerState
  extend DealerBetting

  @die_1 = STANDARD_DIE
  @die_2 = STANDARD_DIE
  @result = [0, 0]
  @round = 1
  @match = 1
  @par = 150

  class << self

    attr_reader :match, :round, :par, :result
    attr_accessor :die_1, :die_2

    def roll_and_advance_round
      roll
      next_round
    end

    def roll
      @result = [@die_1.sample, @die_2.sample]
    end

    def next_round
      @round += 1
    end

    def next_match
      @round = 0
      @match += 1
      @par *= 6
    end
  end
end

