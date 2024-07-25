# frozen_string_literal: true

class Bank

  private

  ONE_DIE_BONUS = 1.3
  SPECIAL_TYPES = %i[both_dice difference]
  DIFFERENCE_PAYOUT = {
    :"0" => 6,
    :"-1" => 3,
    :"-2" => 4,
    :"-3" => 6,
    :"-4" => 9,
    :"-5" => 18,
  }

  @pot = 0
  @shares = 0

  class << self

    attr_writer :pot, :shares

    def standard_cut
      pot / shares
    end

    def build_pot(players)
      players.each do |player|
        if player.won?
          self.shares += 1 unless SPECIAL_TYPES.include? player.type
        else
          self.pot += player.bet
        end
      end
    end

    def payout(player)
      player.winnings = case player.type
                        when :both_dice
                          pot
                        when :one_die
                          player.bet + (standard_cut * ONE_DIE_BONUS).ceil 
                        when :difference
                          player.bet * DIFFERENCE_PAYOUT[player.guess.to_s.to_sym]
                        else
                          player.bet + standard_cut
                        end
    end

    def cashout(player)
      player.winnings = -player.bet
    end

    def reset!
      self.pot = 0
      self.shares = 0
    end

    public

    attr_reader :pot, :shares

    def settle_up(players)
      build_pot players

      players.each do |player|
        player.won? ? payout(player) : cashout(player)
      end

      reset!
    rescue => e
      puts ""
      puts players.sort_by(&:money).reverse.map { |npc| npc.info.to_s + "\n\n"}
      raise e    
    end
  end
end
