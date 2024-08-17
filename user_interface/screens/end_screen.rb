# frozen_string_literal: true

require_relative 'screen'

class EndScreen < Screen
  def self.screen(player)
    (player.won_game? ? '%s wins!' : '%s loses.') % player.name
  end
end
