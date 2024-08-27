# frozen_string_literal: true

require 'debug'
require_relative '../item'

class Vision < Item
  LEVEL_DISTRIBUTION = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4].freeze

  def initialize(level = LEVEL_DISTRIBUTION.sample)
    super
    self.name = 'vision'
    self.type = :vision
    self.level = level
    self.price_percent = 1.5
    self.item_description = 'An item that sees into the future.'
    self.type_description = 'At higher levels: get more clues and more uses per match.'
  end
end
