# frozen_string_literal: true

SHOP = Screen.new(:title)

SHOP[:title] = "Shop"

def SHOP.item_listing(item)
  [
    '%<name>s $%<price>s',
    '%<type>s - Power: %<power>s',
    '%<description>s',
    UI.divider(40)
  ].map { |line| line % item.stats}
end

def SHOP.to_s(*items)
  [
    contents[:title],
    UI.divider(40)
  ] + 
  items.map do |item|
    item_listing(item)
  end

end
