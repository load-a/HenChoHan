# frozen_string_literal: true

require_relative 'player'
require_relative '../constants'

class HumanPlayer < Player

  MINIMUM_BET_SHORTCUTS = %w[0 - < min minimum least]
  MAXIMUM_BET_SHORTCUTS = %w[00 + > max maximum most]
  PREVIOUS_SHORTCUTS = %w[. = prev previous last]

  @@cheats = []

  def predict # TODO: human guess becomes a signal; verification and processing will be handled after by the GuessReader
    previous_guess = guess || 'cho'

    puts "What is your guess?"

    self.guess = gets.downcase.split(' ')

    self.guess = previous_guess if PREVIOUS_SHORTCUTS.include? guess[0]

    exit if QUIT.include? guess[0]
  end

  def wager
    previous_bet = bet || round_min

    loop do
      puts "What is your bet? #{UI.convert_int_to_money(money)}"

      self.bet = gets.chomp

      self.bet =  if MINIMUM_BET_SHORTCUTS.include? bet
                    1 # round_min
                  elsif MAXIMUM_BET_SHORTCUTS.include? bet
                    money # [round_max, money].min
                  elsif PREVIOUS_SHORTCUTS.include? bet
                    previous_bet
                  elsif bet == 'back' || bet == 'b'
                    self.bet = :back
                    break 
                  else
                    bet.to_i
                  end

      break if bet > 0 && bet <= money
    end
  end

  def self.cheats
    @@cheats
  end

  def cheats
    this.cheats
  end

  def finish_round
    super
    self.streak += ' <-'
  end
end
