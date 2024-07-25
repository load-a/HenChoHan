# frozen_string_literal: true

module DealerBetting
  def maximum_bet
    (par * 0.10).round_up.to_i
  end

  def minimum_bet
    [(par * 0.01).round_down(5).to_i, 1].max
  end

  def starting_range
    (par * 0.15).to_i.round_down..(par * 0.20).to_i.round_up
  end

  def starting_average
    ((par * 0.15).to_i.round_down + (par * 0.20).to_i.round_up) / 2
  end
end
