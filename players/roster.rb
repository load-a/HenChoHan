# frozen_string_literal: true

require_relative 'npc'
require_relative 'human_player'

module PlayerGenerator

  def generate_human(money)
    # puts "What is your name?"
    name = "Saramir" # gets.chomp
    self.human = HumanPlayer.reset(name, money)
  end

  def generate_npcs(money)
    name_list = NPC_NAMES.sample(length)
    self.npcs = name_list.map { |name| NPC.new(name, money) }
  end

  def replace_eliminated_npcs(money = 50)
    npcs.map! do |npc|
      npc.lost_match? ? NPC.new(available_names.sample, money) : npc 
    end
  end

  def available_names
    NPC_NAMES - npcs.map(&:name)
  end
end

module PlayerGroups
  def odds
    all.select do |player|
      player.type == :odd
    end
  end

  def evens
    all.select do |player|
      player.type == :even
    end
  end

  def singles
    all.select do |player|
      player.type == :one_die
    end
  end

  def doubles
    all.select do |player|
      player.type == :both_dice
    end
  end

  def differences
    all.select do |player|
      player.type == :difference
    end
  end

  def odds
    all.select do |player|
      player.type == :odd
    end
  end

  def not_evens
    all.select do |player|
      player.type != :even
    end
  end

  def not_singles
    all.select do |player|
      player.type != :one_die
    end
  end

  def not_doubles
    all.select do |player|
      player.type != :both_dice
    end
  end

  def not_differences
    all.select do |player|
      player.type != :difference
    end
  end

  def others
    [singles, doubles, differences]
  end

  def normals
    [evens, odds]
  end

  def winners
    all.select do |player|
      player.is_a?(NPC) &&
      player.win_status == :round
    end
  end

  def groups
    {
      evens: evens,
      odds: odds,
      singles: singles,
      doubles: doubles,
      differences: differences,
      winners: winners
    }
  end
end

class Roster

  extend PlayerGenerator
  extend PlayerGroups

  @length = 15
  @human = nil
  @npcs = []

  class << self

    attr_accessor :length, :human, :npcs

    def generate_list(money = 50)
      generate_human(money)
      generate_npcs(money)
    end

    # @return [Array<Player>]
    def all
      [human] + npcs
    end

    def play_npcs
      npcs.each(&:predict)
      npcs.each(&:wager)
    end

    def conclude_round
      all.each(&:finish_round)
    end

    def conclude_match
      all.each(&:finish_match)
    end
  end
end
