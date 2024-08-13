# frozen_string_literal: true
require_relative 'bookie'

class Bank # < House
  extend Bookie

  @pot = 0
  @shares = 0

  class << self
    private

    attr_writer :pot, :shares

    public

    attr_reader :pot

    def settle_up(players)
      reset!
      build_pot players

      players.each do |player|
        player.won? ? payout(player) : cashout(player)
      end
    end

    def can_clear_par?(player)
      hypothetical_earnings(player) >= Scorer.par
    end

    def minimum_bet
      [(Scorer.par * 0.01).round_down(5).to_i, 1].max
    end

    def maximum_bet
      (Scorer.par * 0.25).round_up(10).to_i
    end

    def starting_money
      (Scorer.par * 0.05).round_up(10).to_i
    end
  end
end
