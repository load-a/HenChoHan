# frozen_string_literal: true

class DealerStatus < Screen

  def self.screen
    [
      'Dealer',
      'Die 1: %<die_1>s / Die 2: %<die_2>s' % Dealer.dice
    ]
  end
end
