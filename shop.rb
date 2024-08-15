# frozen_string_literal: true

class Shop
  ITEMS = [
    EvenDie, OddDie, HeavyDie, LightDie, Weight.new,
    Coattails.new, Foresight.new, Reroll.new
  ].freeze

  attr_accessor :stock

  def initialize
    self.stock = ITEMS.sample(4)
  end

  def open_for_business
    stock.each do |item|
      item.roll_level if item.respond_to? 'roll_level'
    end

    puts Shop.screen(stock)

    purchase
  end

  private

  def purchase
    loop do
      selection = UI.menu_select(stock, "Buy one item ($#{HumanPlayer.money})")

      if selection.nil?
        break puts 'Shop skipped.' if UI.query 'Skip Shop?'
      elsif selection.price > HumanPlayer.money
        puts 'Cannot afford item.'
      else
        HumanPlayer.inventory << selection
        puts "Purchased #{selection.name}"

        case selection.type
        when :swap_die
          break unless UI.query 'Use now?'
          selection.use
        when :vision
          #use later
        end

        break
      end
    end
  end
end
