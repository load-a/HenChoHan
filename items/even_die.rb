# frozen_string_literal: true

require_relative 'dice_modifier'
require_relative 'item'

class EvenDie < DiceModifier

  self.number = [2, 4, 6]

  self.name = 'Even Die'
  self.price_percent = 2.0
  self.item_description = 'A die with only even numbers.'
end
