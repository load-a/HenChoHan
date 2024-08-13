# frozen_string_literal: true

require_relative 'constants'
require_relative 'guess_reader'

module PlayerState
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
      self.streak += "+"
    else
      self.streak += "-"
    end

    self.rounds += 1
    self.money += winnings

    self.win_status = :eliminated if money < 1
  end
end

class Player
  include PlayerState
  include PlayerActions

  attr_accessor :name, :money, :bet, :guess, :winnings, :wins, 
                :rounds, :streak, :win_status, :elite_status

  def initialize(name, money = 50)
    self.name = name
    self.money = money
    self.winnings = 0
    self.guess = :none
    self.bet = 0

    self.wins = 0
    self.rounds = 0

    self.streak = '......'   

    self.win_status = :none
    self.elite_status = false
  end

  def type
    GuessReader.infer_type guess
  end
end

