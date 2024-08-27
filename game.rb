# frozen_string_literal: true

require_relative 'ending_play'
require_relative 'other_screens'
require_relative 'finishing_round'
require_relative 'user_interface/input/input'

# The main gameplay object.
class Game
  @human = HumanPlayer
  @previous_round = ''
  @break = false

  class << self
    include EndingPlay
    include OtherScreens
    include FinishingRound

    attr_accessor :previous_round, :human

    def setup_game
      Roster.generate_list(Bank.starting_money)
    end

    def play_game
      loop do
        challenge_the_house if human.streak.include? '++++++'
        npc_turn
        preview_first_round
        player_turn
        determine_winners
        human.use_delayed_inventory
        finish_round
        determine_outcomes
        break if @break
      end
    end

    alias setup_new_game setup_game

    # Plays for the npcs.
    # @return [Void]
    def npc_turn
      Roster.replace_eliminated_npcs

      Dealer.roll

      Roster.play_npcs

      Roster.all.each do |player|
        Scorer.determine_round_win(player)
      end
    end

    # Prompts the player for a guess and bet.
    # @return [Void]
    def player_turn
      loop do
        human.predict
        redirect_optional_inputs
        next unless Input.valid_guess? human.guess

        human.wager
        next if human.bet == :back

        break
      end
    end

    def determine_outcomes
      end_game if human.lost_match?

      Scorer.match_over? ? end_match : Dealer.next_round
    end
  end
end
