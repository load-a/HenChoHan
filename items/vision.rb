# frozen_string_literal: true
require 'debug'
require_relative 'item'

class Vision < Item

  LEVEL_DISTRIBUTION = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4].freeze

  def initialize(level = LEVEL_DISTRIBUTION.sample)
    super
    self.name = 'vision'
    self.type = :vision
    self.level = level
    self.price_percent = 1.5
    self.item_description = 'An item that sees into the future.'
    self.type_description = 'At higher levels: get more clues and more uses per match.'
  end

end

class Coattails < Vision
  STATS = %i[
    streak streak streak streak streak streak streak streak
    bet bet bet bet bet bet
    money money money
    guess
    name
  ].freeze

  def initialize
    super()
    self.name = 'Coattails'
    self.item_description = 'Reveal a clue about some winning player(s).'
  end

  def use
    clues = Roster.winners.sample(level)
    clues.map! do |player|
      attribute = STATS.sample
      '%s: %s' % [attribute, player.send(attribute.to_s)]
    end

    puts clues

    super
  end
end

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

class Reroll < Vision
  def initialize
    super()
    self.name = 'Reroll'
    self.type = :delayed_vision
    self.item_description = "Rerolls the next throw if it doesn't land in your favor."
  end

  def use
    level.times do
      Scorer.determine_round_win(HumanPlayer)
      break puts 'human correct' if HumanPlayer.won?

      puts "Rerolling a #{Dealer.result}"
      Dealer.reroll
    end

    super
  end
end
