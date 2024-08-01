# frozen_string_literal: true

# require_relative 'dealer/dealer'

class Scorer

  SAFE_PERCENT = 0.20

  @par = 300
  @elite_index = 0

  class << self

    attr_accessor :par, :elite_index

    def determine_round_win(player)
      player.win_status = if Dealer.correct_guesses.include?(player.guess) ||
                            Dealer.correct_guesses.include?(player.type)
                            :round
                          else
                            :lost
                          end
    end

    def determine_match_win(player) # Only to be used when match is over.
      player.win_status = if player.elite?
                            :match
                          else
                            :eliminated
                          end
    end

    def match_over?(players)
      clear_number = (SAFE_PERCENT * players.length).ceil

      players.count { |player| player.money >= par } >= clear_number
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
