# frozen_string_literal: true

require_relative 'class_extentions'
require_relative 'librarian'

require_relative 'house/dealer/dealer'
require_relative 'house/scorer'
require_relative 'house/bank/bank'

Librarian.require_directory('./items', load_first: './items/item.rb')
Librarian.require_directory('./user_interface')

require_relative 'players/roster'

require_relative 'game'

UserInterface.blank_feed
Game.setup_game # This is disconnected from #play_game to allow for roster changes during development.
HumanPlayer.inventory = [Weight.new(level: 4)]
Game.play_game
