# frozen_string_literal: true

# require_relative 'dealer/dealer'

# Scores the game, sets pars and determines when a match is over.
class Scorer
  SAFE_PERCENT = 0.40
  PROGRESSION_TABLE = [100, 750, 2_000, 8_000, 40_000, 100_000, 250_000].freeze # after this it just doubles

  @par = Dealer.match > 7 ? @par * 2 : PROGRESSION_TABLE[Dealer.match - 1]

  class << self
    attr_accessor :par

    # Compares the player's guess or type to the Dealer's .correct_guess
    #   and the player's @win_status accordingly.
    # @param player [Player, Class<HumanPlayer>]
    # @return [Void]
    def determine_round_win(player)
      player.win_status = if Dealer.correct_guesses.include?(player.guess) ||
                             Dealer.correct_guesses.include?(player.type)
                            :round
                          else
                            :lost
                          end
    end

    # Sets the player's win_status.
    # @note Only to be used when match is over.
    # @return [Void]
    def assign_match_win(player)
      player.win_status = if player.elite?
                            :match
                          else
                            :eliminated
                          end
    end

    # Compares the number of players with Elite status to the clear_number.
    # Returns true when the clear_number is matched or exceeded.
    # @return [Boolean]
    def match_over?
      clear_number = (SAFE_PERCENT * Roster.all.length).ceil

      Roster.all.count { |player| player.money >= par } >= clear_number
    end

    def assign_elites(players)
      players.each do |player|
        player.elite_status = player.money >= par
      end
    end
  end
end
