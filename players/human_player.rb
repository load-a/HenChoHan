# frozen_string_literal: true

require_relative 'player'
require_relative '../constants'

class HumanPlayer
  extend PlayerActions
  extend PlayerState

  MINIMUM_BET_SHORTCUTS = %w[0 - < min minimum least]
  MAXIMUM_BET_SHORTCUTS = %w[00 + > max maximum most]
  PREVIOUS_SHORTCUTS = %w[. = prev previous last]

  class << self
    attr_accessor :name, :money, :bet, :guess, :winnings, :wins, 
                  :rounds, :streak, :win_status, :elite_status, :cheats

    def reset(name = "Saramir", money = 50)
      @name = name
      @money = 300
      
      @winnings = 0
      @guess = 'cho'
      @bet = 1

      @wins = 0
      @rounds = 0

      @streak = '......'   

      @win_status = :none
      @elite_status = false
      type

      @cheats = []

      self
    end

    def predict 
      # NOTE: It's easier for verification and case handling to be done in
      #       the actual gameplay loop instead of here, so any input that 
      #       isn't parsed as a true guess is returned as a String array.
      puts "What is your guess?"

      raw_guess = gets.downcase.split(' ')

      exit if QUIT.include? raw_guess[0]
      return if PREVIOUS_SHORTCUTS.include? raw_guess[0]

      if raw_guess.length > 1 && raw_guess[-1].start_with?('$')
        raw_guess = process_single_line_play(raw_guess) 
      end

      self.guess = GuessReader.format raw_guess

    end

    def process_single_line_play(guess)
      self.bet = guess[-1][1..].to_i.clamp(1, money).to_s
      guess[...-1]
    end

    def wager
      return self.bet = bet.to_i if bet.is_a? String

      previous_bet = bet || 1

      loop do
        puts "What is your bet? #{UI.convert_int_to_money(money)}"

        raw_bet = gets.chomp

        return if PREVIOUS_SHORTCUTS.include? raw_bet

        self.bet =  if MINIMUM_BET_SHORTCUTS.include? raw_bet
                      1 # round_min
                    elsif MAXIMUM_BET_SHORTCUTS.include? raw_bet
                      money # [round_max, money].min
                    elsif raw_bet == 'back' || raw_bet == 'b'
                      self.bet = :back
                      break 
                    else
                      raw_bet.to_i
                    end

        break if (1..money).include? bet
      end
    end

    def finish_round
      super
      self.streak += ' <-'
    end

    def type
      GuessReader.infer_type guess
    end

  end
end
