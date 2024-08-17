# frozen_string_literal: true

class RoundPreview < Screen

  TEMPLATE = '%-15<name>s %6<guess>s %-11<type>s %9<bet>s %<streak>s'
  KEY = {
    name: 'Name',
    guess: 'Guess',
    type: 'Type',
    bet: 'Bet',
    streak: 'Streak',
  }
  LEGEND = TEMPLATE % KEY
  LENGTH = (LEGEND).length

  class << self

    def player_info(player)
      {
        name: player.name,
        guess: player.guess,
        type: player.type,
        bet: UserInterface.convert_integer_to_money(player.bet),
        streak: player.streak
      }
    end

    def header
      [
        '-- Match %i --' % Dealer.match,
        ' - Round %i -' % Dealer.round,
        'Betting Range',
        ' $%i -- $%i' % [Bank.minimum_bet, Bank.maximum_bet],
        'Par: $%i' % Scorer.par,
        'Pot: $%i' % Bank.total_pot,
        'Evens: $%<evens>i  Odds: $%<odds>i  Others: $%<others>i' % Bank.spread,
        ''
      ].map do |string|
        line = Rainbow(string.center(LENGTH))
        line.bold
      end
    end

    def player_line(player)
      line = Rainbow(TEMPLATE % player_info(player))
      line = line.orange.italic if Bank.can_clear_par? player
      line = line.faint.italic if player.bet == player.money
      line
    end

    def screen(players)
      header +
        [Rainbow(LEGEND).underline.italic] +
        players.map do |player|
          player_line(player)
        end +
        [('E:%i, O:%i, #:%i, ##:%i, -#:%i' % Roster.groups.values.map(&:length)).center(LENGTH)]
    end
  end
end
