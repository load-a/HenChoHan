# frozen_string_literal: true

require_relative 'item_function'

# An item that lasts for the duration of the game or until replaced.
class Effect
  extend ItemFunction

  self.name = 'Persistent Item'
  self.level = 1
  self.type = :persistent

  self.item_description = 'Some other kind of item.'
  self.type_description = 'Effect persists until replaced.'

  self.price_percent = 1.0

  class << self
    def inherit_attributes(_parent)
      self.name = 'Persistent Item'
      self.level = 1
      self.type = :persistent

      self.item_description = 'Some other kind of item.'
      self.type_description = 'Effect persists until replaced.'

      self.price_percent = 1.0
    end

    def inherited(child)
      super
      child.inherit_attributes parent: self
    end

    def upgrade
      self.level += 1
      reset
    end
  end
end