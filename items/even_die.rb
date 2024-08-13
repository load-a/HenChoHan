# frozen_string_literal: true

require_relative 'swap_die'

class EvenDie < SwapDie

  NUMBERS = [2, 4, 6]

  @name = 'Even Dice'
  @description = 'A die with only even numbers.'
end
