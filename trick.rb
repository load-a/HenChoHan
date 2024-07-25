# frozen_string_literal: true

class Trick

  attr_accessor :name, :rarity

  def initialize(name, rarity)
    self.name = name
    self.rarity = rarity
  end

end

SHOW_WINNERS = Trick.new("Reveal", 6)
def SHOW_WINNERS.info
  "Chance to reveal a winning player."
end

def SHOW_WINNERS.effect(npcs)

  return unless rand(1..6) + rarity >= 6

  npcs.each do |npc|
    Scorer.determine_win npc
  end

  npc = npcs.select{ |npc| npc.won? == true }.sample

  puts "#{npc.name} #{npc.guess}"

end

puts SHOW_WINNERS.info
