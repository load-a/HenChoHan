# frozen_string_literal: true

# Handles Player input and prompting.
module Input
  module_function

  QUIT = %w[q quit stop done exit end fin finish yameru].freeze
  OPTIONS = %w[n new t tricks r rules s see].freeze

  EVEN = %w[c cho e even].freeze
  ODD = %w[h han o odd].freeze
  DIE = %w[1 2 3 4 5 6].freeze
  NUMBER = %w[2 3 4 5 6 7 8 9 10 11 12].freeze
  DIFFERENCE = %w[0 -1 -2 -3 -4 -5].freeze

  NORMAL = EVEN + ODD

  AFFIRMATIVE = %w[1 y yes hai sou indeed ok sure yeah yea si].freeze
  NEGATIVE = %w[0 n no nai chigau iie nah nope].freeze

  VALID_GUESS = NORMAL + DIE + NUMBER + DIFFERENCE

  def valid_answer?(input)
    (AFFIRMATIVE + NEGATIVE).include? input
  end

  def menu_select(options, prompt = 'Make a selection:')
    puts "#{prompt} #{Rainbow('(name or number)').faint}"
    pick = gets.downcase.chomp

    exit_on_quit pick

    selection = options.select do |option|
      pick == option.name.downcase ||
        pick.to_i == options.index(option) + 1
    end

    selection[0]
  end

  def query(prompt = 'Are you sure?')
    puts prompt
    answer = gets.chomp
    exit_on_quit answer
    AFFIRMATIVE.include? answer
  end

  def continue
    _continue = gets
  end

  def exit_on_quit(input)
    exit if QUIT.include? input
  end
end
