# frozen_string_literal: true

require_relative 'dice_modifier'

class OddDie < DiceModifier

  self.number = [1, 3, 5]

  self.name = 'Odd Die'
  self.price_percent = 2.0
  self.item_description = 'A die with only odd numbers.'
end
