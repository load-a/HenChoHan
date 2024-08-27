# frozen_string_literal: true

require_relative 'vision'

class Foresight < Vision
  CLUES = %i[
    state state state state state state state state state state
    difference
    result_1 result_1 result_1
    result_2 result_2 result_2
    result
  ].freeze

  BEST_CLUE = '%<clue>s: %<reveal>s'
  GOOD_CLUE = '...%<clue_excerpt>s... ...%<reveal_excerpt>s...'
  OK_CLUE = '...%<reveal_excerpt>s...'
  BAD_CLUE = '...%<scramble>s...'

  def initialize(level = 1)
    super
    self.name = 'Foresight'
    self.item_description = 'Reveals a clue about the next result.'
  end

  def use
    clues = CLUES.sample(level)

    level.times do
      accuracy = rand(0..10) + level
      hint = generate_hint(clues)

      display_clue(accuracy, hint)
    end

    super
  end

  private

  def display_clue(accuracy, hint)
    case accuracy.clamp(1, 10)
    when 10
      puts BEST_CLUE % hint
    when 6..9
      puts GOOD_CLUE % hint
    when 2..5
      puts OK_CLUE % hint
    else
      puts BAD_CLUE % hint
    end
  end

  def generate_hint(clues)
    clue = clues.pop.to_s
    reveal = Dealer.send(clue).to_s
    {
      clue: clue,
      reveal: reveal,
      clue_excerpt: clue[rand(clue.length - 1)],
      reveal_excerpt: reveal[rand(reveal.length - 1)],
      scramble: (clue.chars.shuffle + reveal.chars.shuffle).join
    }
  end
end
