# frozen_string_literal: true

require_relative 'player'
require_relative 'npc_behavior'
require_relative '../constants'

class NPC < Player
  include NPCBehavior 

  def initialize(name, money: 50)
    super
    initialize_behavior
    # self.comment = temperment_name[0] + ":" + betting_style_name[0] # TESTING
  end

  def predict
    self.guess = GuessReader.format case guess_style.sample
                                    when :normal
                                      (EVEN + ODD).sample
                                    when :one_die
                                      NUMBER.sample
                                    when :both_dice
                                      [DIE.sample, DIE.sample]
                                    when :difference
                                      DIFFERENCE.sample
                                    end
  end

  def wager
    self.bet = rand(betting_range)
  end
end
