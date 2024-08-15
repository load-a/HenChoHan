# frozen_string_literal: true

require_relative 'player'
require_relative 'npc_behavior'
require_relative '../constants'

class NPC
  include PlayerState
  include PlayerActions
  include NPCBehavior

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

    initialize_behavior
  end

  def predict
    self.guess = GuessReader.format case guess_style.sample
                                    when :normal
                                      (EVEN + ODD).sample
                                    when :one_die
                                      rand(1..6).to_s
                                    when :both_dice
                                      [DIE.sample, DIE.sample]
                                    when :difference
                                      DIFFERENCE.sample
                                    end
  end

  def wager
    self.bet = rand(Bank.minimum_bet..[money, Bank.maximum_bet].min).to_i
  end
end
