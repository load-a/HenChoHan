# frozen_string_literal: true
# require 'debug'

# require_relative 'constants'

require_relative 'house/dealer/dealer'
require_relative 'house/scorer'
require_relative 'house/bank'

require_relative 'ui/ui'
require_relative 'ui/screens/screens'

require_relative 'players/npc'
require_relative 'players/player_list'
require_relative 'players/guess_reader'

# require_relative 'trick'

# LIST - an array of players
# ROSTER - the full PlayerList object

def summarize_round(list)
  puts ROUND_SUMMARY.header
  puts UI.divider(ROUND_SUMMARY.key.length)
  list.each do |player|
    line = Rainbow(ROUND_SUMMARY.line(player))

    line = line.faint if player.lost_game? 

    if player.is_a? HumanPlayer
      puts player.make_money? ? line.green : line.red
    elsif player.won?
      puts line.bright
    else
      puts line
    end
  end
  puts UI.divider(ROUND_SUMMARY.key.length)
end

def preview_round(list)
  puts PREVIEW.header
  puts UI.divider(PREVIEW.key.length)
  list.each do |player|
    puts Rainbow(PREVIEW.line(player))
  end
  puts UI.divider(PREVIEW.key.length)
end

def play_game
  roster = PlayerList.new(length: 17, money_range: Dealer.starting_range)
  roster.par = Dealer.par
  human = roster.human

  # roster.human.tricks = SHOW_WINNERS

  roster.assign_betting_range(Dealer.minimum_bet, Dealer.maximum_bet)

  PREVIEW[:dealer] = Dealer
  ROUND_SUMMARY[:dealer] = Dealer

  loop do

    roster.replace_broke_npcs(Dealer.starting_range)

    Dealer.roll

    roster.play_npcs

    if Dealer.round == 1
      preview_round roster.npcs.sort_by(&:name)
    end

    # roster.human.tricks.effect(roster.npcs)

    loop do
      human.predict

      human.guess = GuessReader.format(human.guess)

      next unless GuessReader.valid? human.guess

      case human.guess
      when 's', 'see'
        next preview_round roster.npcs.sort_by(&:name)
      when 'r', 'rules'
        system 'cat ui/rules.txt'
        next puts "*  * *".center(80)
      end

      roster.human.wager

      next if human.bet == :back

      break
    end

    roster.all.each { |player| Scorer.determine_win player } 

    Bank.settle_up roster.all

    roster.conclude_round

    roster.adjust_minimum_bets

    summarize_round roster.all.sort_by(&:money).reverse

    Dealer.next_round

    # UI.clear_screen

    # case `tput cols`.to_i
    # else
    #   summarize_round roster.all.sort_by(&:money).reverse
    # end

    break puts "You lose." if human.lost_game?

    if roster.match_over? Dealer.par
      puts "MATCH END!"

      # File.write "MatchSummary#{Dealer.match}.txt", UI.match_summary(roster.all + roster.eliminated_players).join("\n")

      break puts "You will not be moving on." if roster.human_lost_match?

      puts "You're moving on to the next match! (Press Enter to continue)"

      _continue = gets.chomp

      roster.replace_eliminated_npcs

      Dealer.next_match

      roster.par = Dealer.par
      roster.assign_betting_range(Dealer.minimum_bet, Dealer.maximum_bet)
      roster.all.each(&:finish_match)
    end

    if Dealer.match >= 6
      puts "Game over"
      File.write "WinnerRecord", roster.all.sort_by(&:money).last.match_record.join("\n")
      break
    end

  end
end

UI.clear_screen

puts START_SCREEN

play_game
