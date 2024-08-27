# frozen_string_literal: true

require_relative 'item'

class OtherPeoplesProperty < Item
  def initialize(_level = 1)
    super
    self.name = "Other People's Property"
    self.type = :final_item
    self.item_description = "Steal a successful player's winnings."
    self.type_description = 'Higher levels steal from more people.'
  end

  def use
    Bank.settle_up Roster.all

    level.times do
      break 'No winners to steal from...' if Roster.winners.empty?

      mark = Roster.winners.sample
      HumanPlayer.winnings += mark.winnings
      puts "Stole from #{mark.name} (+#{mark.winnings})"
      mark.winnings = 0
    end

    super
  end
end
