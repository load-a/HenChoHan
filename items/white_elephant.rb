# frozen_string_literal: true

require_relative 'item'

class WhiteElephant < Item
  def initialize(_level = 1)
    super
    self.name = 'White Elephant'
    self.type = :delayed_item
    self.item_description = "Steal a successful player's guess."
    self.type_description = 'Higher levels steal from more people.'
  end

  def use
    return puts 'No winners to steal from...' if Roster.winners.empty?

    pool = Roster.winners.sample(level)

    highest_win = pool.map(&:winnings).max

    mark = pool.select { |player| player.winnings == highest_win }[0]

    old_guess = HumanPlayer.guess

    HumanPlayer.guess = mark.guess
    mark.guess = old_guess
    mark.type = HumanPlayer.type

    puts "Stole guess from #{mark.name}."

    Scorer.determine_round_win(HumanPlayer)
    HumanPlayer.type = Input.infer_guess_type(HumanPlayer.guess)

    super
  end
end
