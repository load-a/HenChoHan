# frozen_string_literal: true
require 'debug'
require_relative 'item'

class Vision < Item 

  LEVEL_DISTRIBUTION = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4]

  @@type = :vision
  @@price_percent = 1.5

  attr_accessor :name, :type, :price_percent, :level, :uses, :uses_left

  def initialize(level = 1)
    self.type = @@type
    @description = ""
    self.level = level
    self.uses = level
    self.uses_left = uses
  end

  def price
    @@price_percent * Scorer.par * level
  end

  def description
    @description +
    "\nAt higher levels: get more clues and more uses per match."
  end

  def reset
    self.uses_left = uses
  end

  def roll_level
    self.level = LEVEL_DISTRIBUTION.sample
  end

  def upgrade
    self.level += 1
    self.uses = level
  end

  def stats
    {
      name: name,
      description: description,
      price: price,
      type: type,
      level:level,
      uses: uses,
      uses_left: uses_left
    }
  end
end

class Coattails < Vision
  STATS = %i[
    streak streak streak streak streak streak streak streak 
    bet bet bet bet bet bet 
    money money money 
    guess 
    name 
  ]

  def initialize(level = 1)
    super
    self.name = "Coattails"
    @description = "Reveal a clue about some winning player(s)."
  end

  def use
    clues = Roster.winners.sample(level)
    clues.map! do |player|
      attribute = STATS.sample
      '%s: %s' % [attribute, player.send(attribute.to_s)]
    end

    self.uses_left -= 1

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
  ]

  def initialize(level = 1)
    super
    self.name = "Foresight"
    @description = "Reveals a clue about the next result."
  end

  def use
    clues = CLUES.sample(level)

    level.times do 
      clue = clues.pop.to_s
      reveal = Dealer.send(clue).to_s
      accuracy = rand(0..10) + level

      case accuracy.clamp(1, 10)
      when 10
        puts "#{clue}: " + reveal
      when 6..9
        puts "..." + clue[rand(clue.length - 1)] + "... ..." + reveal[rand(reveal.length - 1)] + "..."
      when 2..5
        puts "..." + reveal[rand(reveal.length - 1)] + "..."
      else
        puts "..." + (clue.chars.shuffle + reveal.chars.shuffle).join('') + "..."
      end
    end
    super
  end

end

class Delay < Vision

  def initialize(level = 1)
    super
  end
end

class Reroll < Delay
  def initialize(level = 1)
    super
    self.name = "Reroll"
    @description = "Rerolls the next throw if it doesn't land in your favor."
  end

  def use
    level.times do
      Scorer.determine_round_win(HumanPlayer)
      break puts "human correct" if HumanPlayer.won?
      puts "Rerolling a #{Dealer.result}"
      Dealer.reroll
    end

    super
  end
end
