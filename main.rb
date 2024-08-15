# frozen_string_literal: true
# require 'debug'

require_relative 'constants'

require_relative 'house/dealer/dealer'
require_relative 'house/scorer'
require_relative 'house/bank/bank'

require_relative 'ui/ui'
require_relative 'ui/screens/screens'

require_relative 'players/npc'
require_relative 'players/roster'
require_relative 'players/guess_reader'

require_relative 'items/all_items'

require_relative 'game'
require_relative 'shop'

UI.blank_feed
Game.setup_game
HumanPlayer.inventory += [Coattails.new, Foresight.new, Reroll.new]
Game.play_game
