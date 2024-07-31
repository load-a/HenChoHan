# frozen_string_literal: true

class Shop < Screen

  TITLE = "Shop"
  SHOP_LENGTH = 50

  class << self
    def item_listing(item)
      [
        '%<name>s $%<price>s',
        '%<type>s',
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
