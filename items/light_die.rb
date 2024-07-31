# frozen_string_literal: true

require_relative 'swap_die'

class LightDie < SwapDie

  NUMBERS = [1, 2, 3]

  @name = 'Light Dice'
  @base_price = 200
  @description = 'A die with the numbers 1, 2 and 3.'
end
