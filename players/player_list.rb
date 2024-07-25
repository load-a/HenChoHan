# frozen_string_literal: true

require_relative 'npc'
require_relative 'human_player'

class PlayerList

  attr_accessor :npcs, :human, :length, :top_players, :par, :betting_range, :eliminated_players

  def initialize(human: Player.new("No One"), npcs: [], length: 5, money_range: (10..15))
    self.length = length
    self.human = human
    self.npcs = npcs

    generate_npcs(money_range) if npcs.empty?
    generate_human_player unless human.is_a? HumanPlayer

    self.eliminated_players = []
  end

  def all
    npcs + [human]
  end


  def available_names
    NPC_NAMES - npcs.map(&:name)
  end

  def replace_broke_npcs(money_range = 25..50)
    npcs.map! do |npc|
      if npc.money < npc.round_min
        eliminated_players << npc
        NPC.new(available_names.sample, money: rand(money_range)) 
      else
        npc
      end
    end
  end

  def generate_npcs(money_range = (10..15))
    name_list = NPC_NAMES.sample(length) #Fills the screen, minus the 4 normal lines for human player's bet
    name_list.each { |name| npcs << NPC.new(name, money: rand(money_range)) }
  end

  def generate_human_player(money = 12)
    # puts "What is your name?"
    player_name = "Saramir" #gets.chomp[...15]
    self.human = HumanPlayer.new(player_name, money: money)
  end

  def play_npcs
    npcs.each(&:predict)
    npcs.each(&:wager)
  end

  def match_over?(par, safe_percent: 0.2)
    clear_number = (safe_percent * length).ceil

    all.count { |player| player.money >= par } >= clear_number
  end

  def conclude_match
    all.each(&:finish_match)
    eliminated_players = []
  end

  def conclude_round
    all.each(&:finish_round)
    decide_top_players
  end

  def replace_eliminated_npcs # Under normal circumstances this will only be called AFTER top players have been decided
    return if top_players.nil?
    npcs.map! do |npc|
      top_players.include?(npc) ? npc : generate_match_replacement
    end
  end

  def generate_match_replacement
    NPC.new(available_names.sample, money: rand(top_money_range)) 
  end

  def human_lost_game?
    human.money < human.round_min
  end

  def human_lost_match?
    human.money < par
  end

  def human_lost_round?
    human.winnings.positive?
  end

  def human_guess_is?(this)
    human.guess == this
  end

  def human_advance?
    top_players.include? human
  end

  def decide_top_players
    self.top_players = all.select { |player| player.money >= par }
  end

  def top_money_range
    money = top_players.map(&:money)
    (money.min..money.max)
  end

  def adjust_minimum_bets
    betting_min = betting_range[0]

    all.each do |player|
      if top_players.include? player
        player.round_min = [betting_min * 30, player.money, player.round_max].min
      else
        player.round_min = betting_min
      end
    end
  end

  def top_player_index
    top_players&.length || -1
  end

  def assign_betting_range(min, max)
    self.betting_range = [min, max]

    all.each do |player|
      player.round_min = min
      player.round_max = max
    end
  end
end
