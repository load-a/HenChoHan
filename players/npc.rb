# frozen_string_literal: true

require_relative 'player'
require_relative 'npc_behavior'
require_relative '../class_extentions'

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
    prediction = case guess_style.sample
                 when :normal
                   (EVEN + ODD).sample
                 when :one_die
                   rand(1..6).to_s
                 when :both_dice
                   "#{DIE.sample} #{DIE.sample}"
                 when :difference
                   DIFFERENCE.sample
                 end

    guess_output = Input.evaluate_guess(prediction)

    self.guess = guess_output[:guess]
    self.type = guess_output[:type]
  end

  def wager
    self.bet = rand(Bank.minimum_bet..[money, Bank.maximum_bet].min).to_i
  end
end
