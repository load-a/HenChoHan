# frozen_string_literal: true

require_relative 'constants'
require_relative 'librarian'

require_relative 'house/dealer/dealer'
require_relative 'house/scorer'
require_relative 'house/bank/bank'

Librarian.require_directory('./user_interface')

require_relative 'players/roster'

Librarian.require_directory('./items')

require_relative 'game'

UserInterface.blank_feed
Game.setup_game # This is disconnected from #play_game to allow for roster changes during development.
# HumanPlayer.inventory += [Coattails.new, Foresight.new, Reroll.new]
Game.play_game
