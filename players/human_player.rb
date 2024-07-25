# frozen_string_literal: true

require_relative 'player'
require_relative '../constants'

class HumanPlayer < Player

  MINIMUM_BET_SHORTCUTS = %w[0 - < min minimum least]
  MAXIMUM_BET_SHORTCUTS = %w[00 + > max maximum most]
  PREVIOUS_SHORTCUTS = %w[. = prev previous last]

  attr_accessor :tricks

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
      puts "What is your bet? #{money_string} (#{betting_range_string})"

      self.bet = gets.chomp

      self.bet =  if MINIMUM_BET_SHORTCUTS.include? bet
                    round_min
                  elsif MAXIMUM_BET_SHORTCUTS.include? bet
                    [round_max, money].min
                  elsif PREVIOUS_SHORTCUTS.include? bet
                    previous_bet
                  elsif bet == 'back' || bet == 'b'
                    self.bet = :back
                    break 
                  else
                    bet.to_i
                  end

      break if betting_range.include? bet
    end
  end

  def betting_range_string
    "#{convert_cash_to_string(round_min)}--#{convert_cash_to_string(round_max)}"
  end

  def finish_round
    super
    self.streak = streak + " <-"
  end
end
