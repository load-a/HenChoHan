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
        bet: UI.convert_int_to_money(player.bet),
        streak: player.streak
      }
    end

    def header
      [
        '-- Match %i --' % Dealer.match,
        ' - Round %i -' % Dealer.round,
        'Par: $%i' % Scorer.par,
        ''
      ].map do |string|
        line = Rainbow( string.center(LENGTH) )
        line.bold
      end
    end

    def player_line(player)
      TEMPLATE % player_info(player)
    end

    def screen(players)
      header +
      [Rainbow(LEGEND).underline.italic] +
      players.map do |player|
        player_line(player)
      end
    end
  end
end
