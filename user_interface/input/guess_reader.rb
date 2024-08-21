# frozen_string_literal: true

require_relative '../../class_extentions'

# Handles player guesses (see HumanPlayer.predict) specifically.
module GuessReader
  # Prompts user for a guess. Uses guess to assign player guess and type.
  # If the guess is a valid play, a guess Hash is used for the assignment.
  # Otherwise, if it is a Back command or an Option command, the original string
  # is returned and the Input.type is used.
  def guess
    await_valid_input 'Make a guess.' do |answer|
      guess = evaluate_guess answer
      return answer if option? || guess[:guess] == :none || back?
      return guess if guess[:valid]
    end
  end

  # Can be used to process any guess input.
  def evaluate_guess(guess)
    guess = guess.split
    guess = format_guess(guess.length > 1 ? guess : guess.first)
    {
      guess: guess,
      type: infer_guess_type(guess),
      valid: valid_guess?(guess)
    }
  end

  # Checks if the guess is of a valid type and value.
  def valid_guess?(guess)
    infer_guess_type(guess) != :none
  end

  private

  # @return [Symbol]
  def infer_guess_type(guess)
    if guess.is_a? Array
      :both_dice
    elsif guess.is_a? String
      guess_odd_or_even?(guess)
    elsif guess.negative? or guess.zero?
      :difference
    elsif DIE.include? guess.to_s
      :one_die
    else
      :none
    end
  end

  # Converts a guess string into the appropriate data type.
  # @return [Array<Integer, Integer>, Symbol, Integer, String]
  def format_guess(guess)
    return :none if guess.empty?

    if guess.is_a? Array
      guess[0..1].map do |number|
        number.to_i.clamp(1, 6)
      end
    elsif guess.numeric?
      guess = guess.to_i
      guess.positive? ? guess.clamp(1, 6) : guess.clamp(-5, 0)
    else
      guess
    end
  end

  # Returns the appropriate symbol for the guess.
  def guess_odd_or_even?(guess)
    if EVEN.include?(guess)
      :even
    elsif ODD.include?(guess)
      :odd
    else
      :none
    end
  end
end
