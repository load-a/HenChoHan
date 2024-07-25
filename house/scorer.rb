# frozen_string_literal: true

require_relative 'dealer/dealer'

module Scorer

  module_function

  def determine_win(player)
    player.won_round = case player.type
                       when :even, :odd
                         Dealer.state == player.type
                       when :one_die
                         Dealer.result.any? player.guess
                       when :both_dice
                         Dealer.result.sort == player.guess.sort
                       when :difference
                         Dealer.difference == player.guess.abs
                       end
  end
end
