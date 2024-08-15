# frozen_string_literal: true

require_relative 'item_function'
require_relative 'dice_swapper'
require_relative 'Effect'

class DiceModifier < Effect
  extend ItemFunction
  extend DiceSwapper

  MOD_DESCRIPTION = 'Changes the numbers of a die.'

  class << self
    def inherit_attributes(_parent)
      super
      self.type = :dice_modifier
      self.type_description = MOD_DESCRIPTION
    end
  end
end
