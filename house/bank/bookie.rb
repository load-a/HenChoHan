# frozen_string_literal: true

module Bookie

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

  private

  def standard_cut
    @pot / @shares
  end

  def build_pot(players)
    players.each do |player|
      begin
      if player.won?
        @shares += 1 unless SPECIAL_TYPES.include? player.type
      else
        @pot += player.bet
      end
      rescue
        puts '%s: $%s' % [player.name, player.bet]
      end
    end
  end

  def payout(player)
    player.winnings = case player.type
                      when :both_dice
                        @pot
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
    @pot = 0
    @shares = 0
  end

  public

  attr_reader :pot, :shares

end
