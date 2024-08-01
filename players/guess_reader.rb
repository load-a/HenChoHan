# frozen_string_literal: true

require_relative '../constants'

module GuessReader
  module_function

  def infer_type(guess)
    if guess.is_a? Array
      :both_dice
    elsif guess.is_a? String
      if EVEN.include?(guess)
        :even
      elsif ODD.include?(guess)
        :odd
      end
    elsif guess.negative? or guess.zero?
      :difference
    elsif DIE.include? guess.to_s
      :one_die
    else
      raise "Bad guess: #{guess}"
    end
  rescue
    :none
  end

  def format(guess)
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
      VALID_INPUT.include? guess.to_s
    end
  end
end
