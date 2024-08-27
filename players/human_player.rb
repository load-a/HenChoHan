# frozen_string_literal: true

require_relative 'player'
require_relative '../class_extentions'

class HumanPlayer < Player
  extend PlayerActions
  extend PlayerState

  MINIMUM_BET_SHORTCUTS = %w[0 - < min minimum least].freeze
  MAXIMUM_BET_SHORTCUTS = %w[00 + > max maximum most].freeze
  PREVIOUS_SHORTCUTS = %w[. = prev previous last].freeze

  class << self
    # @!attribute inventory
    #   @return [Array<Item, Effect>]
    # @!attribute delayed_inventory
    #   @return [Array<Item, Effect>]
    attr_accessor :inventory, :delayed_inventory, :final_inventory

    # @return [Class<HumanPlayer>]
    def reset(name = 'Saramir', money = 50)
      self.name = name
      self.money = money

      self.winnings = 0
      self.guess = 'cho'
      self.bet = 1

      self.wins = 0
      self.rounds = 0

      self.streak = '......'

      self.win_status = :none
      self.elite_status = false

      self.inventory = []
      self.delayed_inventory = []
      self.final_inventory = []

      self
    end

    def predict
      # NOTE: It's easier for verification and case handling to be done in
      #       the actual gameplay loop instead of here, so any input that
      #       isn't parsed as a true guess is returned as a String array.

      guess_input = Input.guess

      return if PREVIOUS_SHORTCUTS.include? guess_input

      if Input.option? || Input.back?
        self.guess = guess_input
        self.type = Input.type
      else
        self.guess = guess_input[:guess]
        self.type = guess_input[:type]
      end

      # raw_guess = process_single_line_play(raw_guess) if raw_guess.length > 1 && raw_guess[-1].start_with?('$')
    end

    # def process_single_line_play(guess)
    #   self.bet = guess[-1][1..].to_i.clamp(1, money).to_s
    #   guess[...-1]
    # end

    def wager
      return self.bet = bet.to_i if bet.is_a? String

      loop do
        puts "What is your bet? #{UserInterface.convert_integer_to_money(money)}"

        raw_bet = gets.chomp

        return if PREVIOUS_SHORTCUTS.include? raw_bet

        self.bet = if MINIMUM_BET_SHORTCUTS.include? raw_bet
                     Bank.minimum_bet
                   elsif MAXIMUM_BET_SHORTCUTS.include? raw_bet
                     [money, Bank.maximum_bet].min
                   elsif %w[back b].include?(raw_bet)
                     self.bet = :back
                     break
                   else
                     raw_bet.to_i
                   end

        break if (Bank.minimum_bet..money).include? bet
      end
    end

    def finish_round
      super
      self.streak += ' <-'
    end

    def use(item)
      return unless item.uses_left.positive?

      if %i[delayed_vision delayed_item].include? item.type
        if delayed_inventory.include? item
          puts 'Already in use'
        else
          delayed_inventory << item
        end
        puts "#{item.name} activated."
      elsif item.type == :final_item
        if final_inventory.include? item
          puts 'Already in use'
        else
          final_inventory << item
        end
        puts "#{item.name} activated."
      else
        item.use
      end
    end

    def use_delayed_inventory
      delayed_inventory.each(&:use)
      delayed_inventory.clear
    end

    def use_final_inventory
      final_inventory.each(&:use)
      final_inventory.clear
    end
  end
end
