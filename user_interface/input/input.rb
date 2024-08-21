# frozen_string_literal: true

# Testing only
require 'rainbow'
require_relative '../../class_extentions'
require_relative '../../constants'
# ----
require_relative 'guess_reader'
require_relative 'interrogator'
require_relative 'classifier'

# Gets, processes and remembers user input.
class Input
  extend GuessReader
  extend Interrogator
  extend Classifier

  @answer = ''

  class << self
    attr_reader :answer

    # Receives input, normalizes it, then assigns it to @user_input.
    # @note This is intended to only be used as a void method.
    #   Its main purpose is to assign a value to @user_input.
    #   It does return a String, however.
    # @return [Void<String>]
    def get
      @answer = gets.chomp.downcase
    end

    # Prints the prompt and calls .get for input.
    # @note This is intended to only be used as a void method.
    # @return [Void<String>] A processed version of the input it received.
    def ask(prompt)
      puts prompt
      get
    end

    # Delays gameplay until user presses Enter.
    # @return [Void]
    def continue(prompt = 'Press enter to continue.')
      puts Rainbow(prompt).faint
      gets
    end

    # Attempts to exit the game. Asks for confirmation beforehand.
    # @return [Void]
    def exit_on_quit
      return unless quit?

      ask 'Do you want to quit the game?'
      exit if yes?
    end
  end
end
