# frozen_string_literal: true

require_relative 'item_function'

class Item
  include ItemFunction

  def initialize(level = 1)
    super()
    self.name = 'Consumable Item'
    self.level = level
    self.type = :consumable

    self.item_description = 'Some kind of item.'
    self.type_description = 'It does something ig idk.'

    self.price_percent = 1.0
    self.uses_left = level
  end
end

