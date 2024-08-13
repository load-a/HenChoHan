# frozen_string_literal: true

require_relative 'swap_die'

class OddDie < SwapDie

  NUMBERS = [1, 3, 5]

  @name = 'Odd Dice'
  @description = 'A die with only odd numbers.'
end
