# frozen_string_literal: true

ROUND_SUMMARY = Screen.new(:dealer, :key)

ROUND_SUMMARY[:key] = {
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

def ROUND_SUMMARY.template
  '%-15<name>s %6<guess>s %-11<type>s %-9<bet>s %9<winnings>s %9<money>s %4<wins>s/%-4<rounds>s %<streak>s'
end

def ROUND_SUMMARY.player_content(player)
  {
    name: player.name,
    guess: player.guess,
    type: player.type,
    bet: player.bet_string,
    winnings: player.winnings_string,
    money: player.money_string,
    wins: player.total_wins,
    rounds: player.rounds,
    streak: player.streak
  }
end

def ROUND_SUMMARY.dealer_content
  dealer = contents[:dealer]
  {
    match: dealer.match,
    round: dealer.round,
    first_die: dealer.result[0],
    second_die: dealer.result[1],
    state: dealer.state,
    difference: dealer.difference,
    par: dealer.par,
    min: dealer.minimum_bet,
    max: dealer.maximum_bet
  }
end

def ROUND_SUMMARY.key
  (template % contents[:key])
end

def ROUND_SUMMARY.header
  [
    '~~ Match %<match>i - Round %<round>i ~~',
    '[%<first_die>i] [%<second_die>i]',
    '%<state>s (-%<difference>i)',
    'Par: $%<par>i',
    '(%<min>i..%<max>i)',
    ''
  ].map do |line|
    (line % dealer_content).center(key.length)
  end << key
end

def ROUND_SUMMARY.line(player)
  template % player_content(player)
end
