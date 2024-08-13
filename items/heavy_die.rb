# frozen_string_literal: true

require_relative 'swap_die'

class HeavyDie < SwapDie

  NUMBERS = [4, 5, 6]

  @name = 'Heavy Dice'
  @description = 'A die with the numbers 4, 5, and 6.'
end
