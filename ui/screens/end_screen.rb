# frozen_string_literal: true

require_relative 'screen'

END_SCREEN = Screen.new(:won_game, :player_name)

def END_SCREEN.to_s
  (contents[:won_game] ? '%s wins!' : '%s loses.') % contents[:player_name]
end
