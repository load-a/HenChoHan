# frozen_string_literal: true

module Bookie

  ONE_DIE_BONUS = 1.3
  SPECIAL_TYPES = %i[both_dice difference one_die]
  DIFFERENCE_PAYOUT = {
    :"0" => 6,
    :"-1" => 3,
    :"-2" => 4,
    :"-3" => 6,
    :"-4" => 9,
    :"-5" => 18,
  }

  private

  def build_pot(players)
    players.each do |player|
      begin
      if player.won?
        self.shares += 1 unless SPECIAL_TYPES.include? player.type
      else
        self.pot += player.bet
      end
      rescue
        puts '%s: $%s' % [player.name, player.bet]
      end
    end
  end

  def earnings(player)
    case player.type
    when :both_dice
      total_pot
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

  def payout(player)
    player.winnings = earnings(player)
  end

  def reset!
    self.pot = 0
    self.shares = 0
  end

  public

  attr_reader :pot, :shares

  def spread
    {
      evens: Roster.evens.map(&:bet).sum, 
      odds: Roster.odds.map(&:bet).sum, 
      singles: Roster.singles.map(&:bet).sum, 
      doubles: Roster.doubles.map(&:bet).sum, 
      differences: Roster.differences.map(&:bet).sum, 
      normals: Roster.normals.map { |type| type.map(&:bet).sum }.sum,
      others: Roster.others.map { |type| type.map(&:bet).sum }.sum
    }
  end

  def total_pot
    spread.values.sum
  end

  def standard_cut
    pot / shares
  end

  def hypothetical_earnings(player)
    evens = player.bet + spread[:odds] / [Roster.evens.length, 1].max
    odds = player.bet + spread[:evens] / [Roster.odds.length, 1].max

    case player.type
    when :even
      evens
    when :odd
      odds
    when :one_die
      player.bet + (((evens + odds) / 2) * ONE_DIE_BONUS).ceil
    when :both_dice
      total_pot
    when :difference
      player.bet * DIFFERENCE_PAYOUT[player.guess.to_s.to_sym]
    end
  end
end
