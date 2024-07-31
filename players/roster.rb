# frozen_string_literal: true

require_relative 'npc'
require_relative 'human_player'

module PlayerGenerator

  def generate_human(money)
    # puts "What is your name?"
    name = "Saramir" # gets.chomp
    self.human = HumanPlayer.new(name, money: money)
  end

  def generate_npcs(money)
    name_list = NPC_NAMES.sample(length)
    self.npcs = name_list.map { |name| NPC.new(name, money: money) }
  end

  def replace_eliminated_npcs(money = 50)
    npcs.map! do |npc|
      npc.lost_match? ? NPC.new(available_names.sample, money: money) : npc 
    end
  end

  def available_names
    NPC_NAMES - npcs.map(&:name)
  end
end

class Roster

  extend PlayerGenerator

  @length = 15
  @human = nil
  @npcs = []

  class << self

    attr_accessor :length, :human, :npcs

    def generate_list(money: 50)
      generate_human(money)
      generate_npcs(money)
    end

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
