# frozen_string_literal: true

require_relative 'vision'

class Reroll < Vision
  def initialize(_level = 1)
    super
    self.name = 'Reroll'
    self.type = :delayed_vision
    self.item_description = "Rerolls the next throw if it doesn't land in your favor."
  end

  def use
    level.times do
      Scorer.determine_round_win(HumanPlayer)
      break puts 'human correct' if HumanPlayer.won?

      puts "Rerolling a #{Dealer.result}"
      Dealer.reroll
    end

    super
  end
end
