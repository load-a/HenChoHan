# frozen_string_literal: true
require_relative 'bookie'

class Bank # < House
  extend Bookie

  @pot = 0
  @shares = 0

  class << self
    def settle_up(players)
      build_pot players

      players.each do |player|
        player.won? ? payout(player) : cashout(player)
      end

      reset!   
    end
  end
end
