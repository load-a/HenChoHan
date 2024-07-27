# frozen_string_literal: true

# require_relative 'dealer/dealer'

module Scorer

  module_function

  def determine_win(player)
    player.won_round =  Dealer.correct_guesses.include?(player.guess) ||
                        Dealer.correct_guesses.include?(player.type)
  end
end
