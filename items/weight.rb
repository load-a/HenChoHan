# frozen_string_literal: true

require_relative 'dice/dice_swapper'
require_relative 'item'

class Weight < Item
  include DiceSwapper

  def initialize(level: 1, number: rand(1..6))
    super(level)
    self.name = 'Weight'
    self.type = :weight
    self.number = Array.new(level, number)
    self.item_description = "Increases the likelihood of rolling a #{number}."
    self.type_description = 'Higher levels increase the odds.'
    self.price_percent = 1.0
  end
end
