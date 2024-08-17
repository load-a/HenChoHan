# frozen_string_literal: true

require_relative 'constants'
require_relative '../user_interface/guess_reader'

module PlayerState
  attr_accessor :name, :money, :bet, :guess, :winnings, :wins,
                :rounds, :streak, :win_status, :elite_status

  def type
    GuessReader.infer_type guess
  end

  def won_game?
    win_status == :game
  end

  def won_round?
    win_status == :round
  end

  alias won? won_round?

  def won_match?
    win_status == :match
  end

  def lost_round?
    win_status == :lost
  end

  def lost_match?
    win_status == :eliminated
  end

  def broke?
    money < Bank.minimum_bet
  end

  def made_money?
    winnings.positive?
  end

  def elite?
    elite_status
  end
end

module PlayerActions
  def finish_round
    self.streak = streak[1...6]

    if won?
      self.wins += 1
      self.streak += '+'
    else
      self.streak += '-'
    end

    self.rounds += 1
    self.money += winnings

    self.win_status = :eliminated if money < 1
  end
end

class Player
  include PlayerActions
  include PlayerState
end

