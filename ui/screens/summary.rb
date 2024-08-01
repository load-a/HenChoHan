# frozen_string_literal: true

class RoundSummary < Screen

  TEMPLATE = '%-15<name>s %6<guess>s %-11<type>s %-9<bet>s %9<winnings>s %9<money>s %4<wins>s/%-4<rounds>s %<streak>s'
  KEY = {
    name: 'Name',
    guess: 'Guess',
    type: 'Type',
    bet: 'Bet',
    winnings: 'Winnings',
    money: 'Money',
    wins: 'Wins',
    rounds: 'Rnds',
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
        winnings: UI.convert_int_to_money(player.winnings),
        money: UI.convert_int_to_money(player.money),
        wins: player.wins,
        rounds: player.rounds,
        streak: player.streak
      }
    end

    def header
      [
        '-- Match %i --' % Dealer.match,
        ' - Round %i -' % Dealer.round,
        '[%i] [%i]' % Dealer.result,
        '%s (-%i)' % [Dealer.state, Dealer.difference],
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
      index = 0

      header +
      [Rainbow(LEGEND).underline.italic] +
      players.map do |player|
        index += 1

        line = Rainbow(player_line(player))

        line = line.bright if player.won?

        line = line.faint if player.lost_match?

        if player == HumanPlayer
          line =  player.made_money? ? line.green : line.red
        end

        line = line.underline if index == Scorer.elite_index
        
        index == players.length ? line.underline : line
      end
    end
  end
end
