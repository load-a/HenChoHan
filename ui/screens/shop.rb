# frozen_string_literal: true

class Shop < Screen

  TITLE = "Shop"
  SHOP_LENGTH = 50

  class << self
    ROMAN_NUMERALS = %w[Z I II III IV V VI VII VIII IX X].freeze
    def item_listing(item)
      [
        '%-10<name>s Lv. %-2<level>s $%<price>s',
        '%<type>s',
        '%<description>s',
        UI.divider(SHOP_LENGTH)
      ].map { |line| Rainbow(line % item.stats)}
    end

    def screen(items)
      index = 0

      [
        TITLE,
        UI.divider(SHOP_LENGTH)
      ] +
        items.map do |item|
          index += 1
          listing = item_listing(item)

          listing.map!(&:faint) if item.price > HumanPlayer.money

          [(ROMAN_NUMERALS[index]).to_s.center(SHOP_LENGTH)] << listing
        end
    end
  end
end
