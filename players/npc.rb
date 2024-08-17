# frozen_string_literal: true

require_relative 'player'
require_relative 'npc_behavior'
require_relative '../constants'

class NPC < Player
  include NPCBehavior

  def initialize(name, money = 50)
    super()
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
                                      (Input::EVEN + Input::ODD).sample
                                    when :one_die
                                      rand(1..6).to_s
                                    when :both_dice
                                      [Input::DIE.sample, Input::DIE.sample]
                                    when :difference
                                      Input::DIFFERENCE.sample
                                    end
  end

  def wager
    self.bet = rand(Bank.minimum_bet..[money, Bank.maximum_bet].min).to_i
  end
end
