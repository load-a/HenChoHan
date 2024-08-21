# frozen_string_literal: true

# Classifies @answer into some general types.
# Independent from the GuessReader.
module Classifier
  TWO_DICE = /\b[1-6] [1-6]\b/.freeze

  # Asks the for input and returns a tag.
  # @param prompt [String] What you want the program to ask.
  # @return [Symbol]
  def read(prompt = 'Please enter some input.')
    ask prompt
    type || :none
  end

  # Analyzes @answer and returns its type.
  # @return [Symbol]
  def type
    return :none if @answer.to_s.empty?

    if quit?
      :quit
    elsif back?
      :back
    elsif answer?
      answer_type
    elsif option?
      option_type
    elsif play?
      play_type
    else
      :none
    end
  end

  # Determines what type of Option @answer is.
  # @return [Symbol]
  def option_type
    OPTION.find { |_type, option| option.include? @answer }[0]
  end

  # Determines what type of response @answer is.
  # @return [Symbol]
  def answer_type
    ANSWER.find { |_type, option| option.include? @answer }[0]
  end

  # Determines what type of Play Command @answer is.
  # @return [Symbol]
  def play_type
    return :number if @answer.numeric?
    return :double if @answer =~ TWO_DICE

    PLAY.find { |_type, option| option.include? @answer }[0]
  end

  # Determines if @answer is a Quit Command.
  # @return [Boolean]
  def quit?
    QUIT.include? @answer
  end

  # Determines if @answer is a Quit Command.
  # @return [Boolean]
  def back?
    BACK.include? @answer
  end

  # Determines if @answer is a Quit Command.
  # @return [Boolean]
  def answer?
    ANSWER.any? { |_type, keywords| keywords.include? @answer }
  end

  # Determines if @answer is a Quit Command.
  # @return [Boolean]
  def option?
    OPTION.any? { |_type, keywords| keywords.include? @answer }
  end

  # Determines if @answer is a Play Command (or Numeric for betting and menu selection).
  # @return [Boolean]
  def play?
    PLAY.any? { |_type, keywords| keywords.include? @answer } ||
      @answer.numeric? || two_dice?
  end

  def two_dice?
    !(@answer =~ TWO_DICE).nil?
  end

  def guess?
    GUESS.any? { |_type, keywords| keywords.include? evaluate_guess(@answer) }
  end

  # Determines if @answer is a Yes Answer.
  # @return [Boolean]
  def yes?
    type == :affirmative
  end

  # Determines if @answer is a No Answer.
  # @return [Boolean]
  def no?
    type == :negative
  end
end
