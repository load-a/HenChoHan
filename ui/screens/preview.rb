# frozen_string_literal: true

PREVIEW = Screen.new(:dealer, :key)

PREVIEW[:key] = {
  name: 'Name',
  guess: 'Guess',
  type: 'Type',
  bet: 'Bet',
  streak: 'Streak',
}

def PREVIEW.template
  '%-15<name>s %6<guess>s %-11<type>s %9<bet>s %<streak>s'
end

def PREVIEW.player_content(player)
  {
    name: player.name,
    guess: player.guess,
    type: player.type,
    bet: player.bet_string,
    streak: player.streak
  }
end

def PREVIEW.dealer_content
  dealer = contents[:dealer]
  {
    match: dealer.match,
    round: dealer.round,
    par: dealer.par,
    min: dealer.minimum_bet,
    max: dealer.maximum_bet
  }
end

def PREVIEW.key
  template % contents[:key]
end

def PREVIEW.header
  [
    '~~ Match %<match>i - Round %<round>i ~~',
    'Par: $%<par>i',
    '(%<min>i..%<max>i)',
    ''
  ].map do |line|
    (line % dealer_content).center(key.length)
  end << key
end

def PREVIEW.line(player)
  template % player_content(player)
end
