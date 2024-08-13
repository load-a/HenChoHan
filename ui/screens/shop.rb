# frozen_string_literal: true

class Shop < Screen

  TITLE = "Shop"
  SHOP_LENGTH = 50

  class << self
    ROMAN_NUMERALS = %w[Z I II III IV V VI VII VIII IX X]
    def item_listing(item)
      [
        '%-10<name>s Lv. %-2<level>s $%<price>s',
        '%<type>s',
        '%<description>s',
        UI.divider(SHOP_LENGTH)
      ].map { |line| line % item.stats}
    end

    def screen(items)
      index = 0
      [
        TITLE,
        UI.divider(SHOP_LENGTH)
      ] +
      items.map do |item|
        index += 1
        ["#{ROMAN_NUMERALS[index]}".center(SHOP_LENGTH)] << item_listing(item)
      end
    end
  end
end
