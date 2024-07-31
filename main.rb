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

puts StartScreen.screen

def run_game
  Roster.generate_list
  human = Roster.human

  loop do

    Roster.replace_eliminated_npcs

    Dealer.roll

    Roster.play_npcs

    puts RoundPreview.screen(Roster.npcs.sort_by(&:name)) if Dealer.first_round?


    loop do 
      human.predict

      human.guess = GuessReader.format human.guess

      case human.guess
      when 's', 'see'
        puts RoundPreview.screen(Roster.npcs)
        next 
      when 'r', 'rules'
        system 'cat ui/rules.txt'
        puts "\n\n"
        next 
      end

      next unless GuessReader.valid? human.guess

      human.wager

      next if human.bet == :back

      break 
    end


    Roster.all.each do |player|
      Scorer.determine_round_win(player)
    end

    Bank.settle_up Roster.all

    Roster.conclude_round

    Scorer.determine_elites Roster.all

    puts RoundSummary.screen(Roster.all.sort_by(&:money).reverse)


    break puts "You lose." if human.lost_match?

    if Scorer.match_over? Roster.all
      puts "Match Over!"

      Roster.all.each do |player|
        Scorer.determine_match_win player
      end

      if human.won_match? 
        puts "You're moving on!"

        Dealer.next_match

        Scorer.par *= 3

        Roster.all.each do |player|
          player.money = 50 * Dealer.match
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

items = [Forsight, Weight.new] # [EvenDie, OddDie, HeavyDie, LightDie, Weight.new]

stock = items.sample(2)

puts Shop.screen(stock)

puts "Pick an Item"
pick = gets.chomp

selection = stock.select { |item| pick == item.name || pick.to_i == stock.index(item) + 1 }[0]

HumanPlayer.cheats << selection

HumanPlayer.cheats.each(&:use)

HumanPlayer.cheats.reject! { |cheat| cheat.destroy? }

puts Dealer.dice

puts HumanPlayer.cheats.map(&:name)
# human.tricks << selection

exit

run_game
