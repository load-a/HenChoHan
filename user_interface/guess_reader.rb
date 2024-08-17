# frozen_string_literal: true

require_relative '../constants'
require_relative 'input'

module GuessReader
  module_function

  DIE = %w[1 2 3 4 5 6].freeze

  def infer_type(guess)
    if guess.is_a? Array
      :both_dice
    elsif guess.is_a? String
      determine_odd_even_input(guess)
    elsif guess.negative? or guess.zero?
      :difference
    elsif Input::DIE.include? guess.to_s
      :one_die
    end
  end

  # Converts a guess string into the appropriate data type.
  # @return [Array<Integer, Integer>, Symbol, Integer, String]
  def format(guess)
    return :none if guess.empty?

    guess = guess[0] unless guess.length > 1

    if guess.is_a? Array
      guess[0..1].map(&:to_i)
    elsif guess.is_numeric?
      guess = guess.to_i
      guess.positive? ? guess.clamp(1, 6) : guess.clamp(-5, 0)
    else
      guess
    end
  end

  def valid?(guess)
    if guess.is_a? Array
      guess.all? { |die| DIE.include? die.to_s }
    else
      Input::VALID_GUESS.include? guess.to_s
    end
  end

  def determine_odd_even_input(guess)
    if Input::EVEN.include?(guess)
      :even
    elsif Input::ODD.include?(guess)
      :odd
    end
  end
end
