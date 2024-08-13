# frozen_string_literal: true

class Cheat < Screen

  TITLE = "Items"
  SHOP_LENGTH = 50

  class << self
    def item_listing(item)
      [
        '%<name>s Lv. %<level>s (%<type>s)',
        'Uses: %<uses_left>s/%<uses>s',
        '%<description>s',
        UI.divider(SHOP_LENGTH)
      ].map { |line| line % item.stats}
    end

    def screen(items)
      [
        TITLE,
        UI.divider(SHOP_LENGTH)
      ] + 
      items.map do |item|
        item_listing(item)
      end
    end
  end
end
