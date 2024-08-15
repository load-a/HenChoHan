# frozen_string_literal: true

# The main gameplay object.
class Game
  @human = HumanPlayer
  @previous_round = ''
  @break = false

  class << self
    attr_accessor :previous_round, :human

    def play_game
      loop do
        npc_turn
        player_turn
        finish_round
        determine_outcomes
        break if @break
      end
    end

    def setup_game
      Roster.generate_list(Bank.starting_money)
    end

    alias setup_new_game setup_game

    def npc_turn
      Roster.replace_eliminated_npcs

      Dealer.roll

      Roster.play_npcs

      Roster.all.each do |player|
        Scorer.determine_round_win(player)
      end

      puts RoundPreview.screen(Roster.npcs.sort_by(&:name)) if Dealer.first_round?
    end

    def player_turn
      loop do
        human.predict
        redirect_optional_inputs
        next unless GuessReader.valid? human.guess

        human.wager
        next if human.bet == :back

        break
      end

      human.use_delayed_inventory
    end

    def redirect_optional_inputs
      case HumanPlayer.guess
      when 'i', 'item', 'items', 'u', 'use'
        manage_inventory
      when 's', 'see'
        preview_round
      when 'r', 'rules'
        system 'cat ui/rules.txt'
      when 'p', 'previous'
        puts previous_round unless Dealer.start_of_game?
      when 'd', 'dealer'
        puts DealerStatus.screen
      when 'm', 'me'
        puts '%s: %s %s' % [human.name, UI.convert_int_to_money(human.money), human.streak]
      end
    end

    def preview_round
      puts RoundPreview.screen(Roster.npcs.sort_by(&:name))
    end

    def manage_inventory
      show_inventory
      return if human.inventory.empty?

      return unless UI.query 'Use an item?'

      puts 'No uses left.' if human.inventory.none? { |item| item.uses_left.positive? }
      select_inventory
    end

    def show_inventory
      if human.inventory.empty?
        puts 'No items.'
      else
        puts Inventory.screen human.inventory
      end
    end

    def select_inventory
      if human.inventory.none? { |item| item.uses_left.positive? }
        puts 'No items are usable.'
      elsif human.inventory.one? { |item| item.uses_left.positive? }
        human.inventory.find { |item| item.uses_left.positive? }.use
      else
        selected_item = UI.menu_select(human.inventory, 'Which one?')
        return if selected_item.nil?
        return puts "#{selected_item.name} is out of uses." if selected_item.uses_left.zero?

        human.use selected_item
      end
    end

    def finish_round
      Roster.all.each do |player|
        Scorer.determine_round_win(player)
      end

      Bank.settle_up Roster.all

      Roster.conclude_round

      Scorer.determine_elites Roster.all

      self.previous_round = RoundSummary.screen(Roster.all.sort_by(&:money).reverse)
      puts previous_round
    end

    def determine_outcomes
      end_game if human.lost_match?

      Scorer.match_over? ? end_match : Dealer.next_round
    end

    def end_match
      puts 'Match Over!'

      Roster.all.each do |player|
        Scorer.determine_match_win player
      end

      if human.won_match?
        open_shop

        setup_next_match
      else
        end_game "You didn't make Elite."
      end
    end

    def open_shop
      puts "You're moving on!#{Rainbow(' (Press Enter to continue.)').faint}"

      UI.continue

      Shop.new.open_for_business
    end

    def setup_next_match
      Dealer.next_match

      Scorer.par *= 3

      Roster.all.each do |player|
        player.money = Bank.starting_money
      end

      HumanPlayer.inventory.each do |item|
        item.reset if item.respond_to? 'reset'
      end
    end

    def end_game(message = 'You ran out of money.')
      puts message, 'You lose.'
      @break = true
    end
  end
end
