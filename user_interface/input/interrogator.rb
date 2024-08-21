# frozen_string_literal: true

# Handles asking the user for specific kinds of input.
module Interrogator
  # Prompts the user for input.
  # Calls the block on said input (answer), Input's state (tag) and the Input class itself (this).
  # These yield parameters (in that order) are all optional.
  # This method will keep the user in a loop until they exit the game or
  # the block returns a truthy value.
  #   Input.await_valid_input("Please enter a normal play.") { |answer, tag, this|
  #     case tag
  #     when :affirmative
  #       puts "Do it then."
  #     when :negative
  #       puts "Yes."
  #     when :normal
  #       puts "Thank you."
  #       true
  #     else
  #       puts "This is not a normal play."
  #     end
  #   }
  #
  #  # => Please enter a normal play.
  #  # => $ no
  #  # => Yes.
  #  # => Please enter a normal play.
  #  # => $ fine
  #  # => Do it then.
  #  # => Please enter a normal play.
  #  # => $ -3
  #  # => This is not a normal play.
  #  # => Please enter a normal play.
  #  # => $ cho
  #  # => Thank you.
  # @yieldparam answer [String] The value of @answer
  # @yieldparam type [Symbol] The value of .type
  # @yieldparam this [Class<Input>] The Input class itself
  # @return [Void]
  def await_valid_input(prompt)
    loop do
      ask prompt

      break if yield @answer, type, Input

      exit_on_quit
    end
  end

  # Has the user select from a list of options by entering their name or position.
  def menu_select(options, prompt = 'Make a selection:')
    pick = ask "#{prompt} #{Rainbow('(Enter the name or number.)').faint}"

    exit_on_quit

    selection = options.select do |option|
      pick == option.name.downcase ||
        pick.to_i == options.index(option) + 1
    end

    selection[0]
  end

  # Asks a yes or no question.
  # @return [Boolean]
  def query(question = 'Are you sure?')
    ask question
    yes?
  end
end
