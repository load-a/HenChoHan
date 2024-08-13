# frozen_string_literal: true
require 'debug'

require_relative 'constants'

require_relative 'house/dealer/dealer'
require_relative 'house/scorer'
require_relative 'house/bank/bank'

require_relative 'ui/ui'
require_relative 'ui/screens/screens'

require_relative 'players/npc'
require_relative 'players/roster'
require_relative 'players/guess_reader'

require_relative 'items/all_items'

require_relative 'game'
require_relative 'shop'

ITEMS = [
  EvenDie, OddDie, HeavyDie, LightDie, Weight.new,
Coattails.new, Foresight.new, Reroll.new
  ]

def run_game
  Roster.generate_list(Bank.starting_money)
  human = Roster.human
  previous_round = ''

  human.items << Reroll.new(4)

  loop do
    Roster.replace_eliminated_npcs

    Dealer.roll

    Roster.play_npcs

    Roster.all.each do |player|
      Scorer.determine_round_win(player)
    end

    puts RoundPreview.screen(Roster.npcs.sort_by(&:name)) if Dealer.first_round?

    loop do 
      human.predict

      case human.guess
      when 'i', 'item', 'items', 'u', 'use'
        if human.items.empty?
          puts 'No items.'
          next
        end

        puts Cheat.screen human.items

        if UI.query 'Use an item?'

          if human.items.none? { |item| item.uses_left.positive? }
            puts 'No uses left.'
            next
          end

          selected_item = if human.items.one? { |item| item.uses_left.positive? }
                            human.items.select { |item| item.uses_left.positive? }[0].use
                          else
                            UI.menu_select(human.items, 'Which one?')
                          end
          human.use selected_item unless selected_item.nil?
        end

        next
      when 's', 'see'
        puts RoundPreview.screen(Roster.npcs.sort_by(&:name))
        next 
      when 'r', 'rules'
        system 'cat ui/rules.txt'
        puts "\n\n"
        next 
      when 'p', 'previous'
        puts previous_round unless Dealer.first_round? && Dealer.match == 1
        next
      when 'd', 'dealer'
        puts DealerStatus.screen
        next
      when 'm', 'me'
        puts '%s: %s %s' % [human.name, UI.convert_int_to_money(human.money), human.streak]
        next
      end

      next unless GuessReader.valid? human.guess

      human.wager

      next if human.bet == :back

      break 
    end

    human.use_delays

    Roster.all.each do |player|
      Scorer.determine_round_win(player)
    end

    Bank.settle_up Roster.all

    Roster.conclude_round

    Scorer.determine_elites Roster.all

    previous_round = RoundSummary.screen(Roster.all.sort_by(&:money).reverse)
    puts previous_round


    break puts 'You lose.' if human.lost_match?

    if Scorer.match_over? Roster.all
      puts 'Match Over!'

      Roster.all.each do |player|
        Scorer.determine_match_win player
      end

      if human.won_match? 
        puts "You're moving on!" + Rainbow(' (Press Enter to continue.)').faint

        UI.continue

        shop

        Dealer.next_match

        Scorer.par *= 3

        Roster.all.each do |player|
          player.money = Bank.starting_money
        end

        HumanPlayer.items.each do |item|
          item.reset if item.respond_to? 'reset'
        end

        # Roster.replace_eliminated_npcs
      else
        puts "Didn't make Elite. Game Over."
        break
      end
    else
      Dealer.next_round
    end
  end
end

def shop
  ITEMS.select { |item| item.type == :vision }.each { |item| item.level = [1, 1, 1, 1, 2, 2, 2, 3, 3, 4].sample }

  stock = (ITEMS - HumanPlayer.items).sample(4)

  stock.each do |item|
    item.roll_level if item.respond_to? 'roll_level'
  end

  puts Shop.screen(stock)

  loop do
    selection = UI.menu_select(stock, "Buy one item ($#{HumanPlayer.money})")

    if selection.nil?
      if UI.query 'Skip Shop?'
        puts 'Shop skipped.'
        break 
      else
        next
      end

    else
      if selection.price > HumanPlayer.money
        next puts 'Cannot afford item.'
      end

      HumanPlayer.items << selection
      puts "Selected #{selection.name}"

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

# puts HumanPlayer.cheats.map(&:name)
UI.blank_feed
puts StartScreen.screen
run_game

