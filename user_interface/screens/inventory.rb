# frozen_string_literal: true

class Inventory < Screen
  TITLE = 'Items'
  SHOP_LENGTH = 50

  class << self
    # @return [Array<Rainbow::Presenter>]
    def item_listing(item)
      [
        '%<name>s Lv. %<level>s (%<type>s)',
        'Uses: %<uses_left>s/%<uses>s',
        '%<description>s',
        UserInterface.divider(SHOP_LENGTH)
      ].map { |line| Rainbow(line % item.stats) }
    end

    def screen(items)
      [
        TITLE,
        UserInterface.divider(SHOP_LENGTH)
      ] +
        items.map do |item|
          listing = item_listing(item)

          listing.map!(&:faint) if item.uses_left.zero?
          listing.map!(&:orange) if HumanPlayer.delayed_inventory.include? item
          listing.map!(&:yellow) if HumanPlayer.final_inventory.include? item

          listing
        end
    end
  end
end
