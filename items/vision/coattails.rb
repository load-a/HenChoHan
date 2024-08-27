require_relative 'vision'

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
      format('%s: %s', attribute, player.send(attribute.to_s))
    end

    puts clues

    super
  end
end
