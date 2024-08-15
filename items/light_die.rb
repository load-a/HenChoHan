# frozen_string_literal: true

require_relative 'dice_modifier'

class LightDie < DiceModifier

  self.number = [1, 2, 3]

  self.name = 'Light Die'
  self.price_percent = 2.0
  self.item_description = 'A die with the numbers 1, 2 & 3.'
end
