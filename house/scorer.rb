# frozen_string_literal: true

# require_relative 'dealer/dealer'

class Scorer
  SAFE_PERCENT = 0.50
  PROGRESSION_TABLE = [100, 750, 2_000, 8_000, 40_000, 100_000, 250_000].freeze # after this it just doubles

  @par = Dealer.match > 7 ? @par * 2 : PROGRESSION_TABLE[Dealer.match - 1]
  @elite_index = 0

  class << self
    attr_accessor :par, :elite_index

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

    def determine_match_win(player)
      # Only to be used when match is over.
      player.win_status = if player.elite?
                            :match
                          else
                            :eliminated
                          end
    end

    def match_over?
      clear_number = (SAFE_PERCENT * Roster.all.length).ceil

      Roster.all.count { |player| player.money >= par } >= clear_number
    end

    def determine_elites(players)
      elites = []

      players.each do |player|
        if player.money >= par
          player.elite_status = true
          elites << player
        else
          player.elite_status = false
        end
      end

      self.elite_index = elites.length

      elites
    end
  end
end
