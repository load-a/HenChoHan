# frozen_string_literal: true

require_relative 'dice_modifier'

class HeavyDie < DiceModifier

  self.number = [4, 5, 6]

  self.name = 'Heavy Die'
  self.price_percent = 2.0
  self.item_description = 'A die with the numbers 4, 5 & 6.'
end
