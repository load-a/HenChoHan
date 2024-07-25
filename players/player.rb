# frozen_string_literal: true

require_relative 'constants'
require_relative 'guess_reader'

module Logger
  attr_accessor :total_winnings, :total_bets, :type_regularity, :highest_win, :lowest_win, :greatest_loss, :least_loss,
    :starting_money, :match_record

  def clear_log
    self.total_winnings = 0
    self.total_bets = 0
    self.type_regularity = {
      odd: 0,
      even: 0,
      one_die: 0,
      both_dice: 0,
      difference: 0
    }
    self.highest_win = 0
    self.lowest_win = 0
    self.greatest_loss = 0
    self.least_loss = 0

    self.starting_money = money

    @match_no = 1
  end

  def accuracy
    total_wins / rounds.to_f
  end

  def log_round
    self.total_winnings += winnings
    self.total_bets += bet
    type_regularity[type] += 1 unless type == :none

    if winnings > highest_win
      self.highest_win = winnings

    elsif lowest_win.zero? && winnings.positive? || winnings < lowest_win && winnings.positive?
      self.lowest_win = winnings

    elsif winnings < greatest_loss
      self.greatest_loss = winnings

    elsif least_loss.zero? && winnings.negative? || winnings > least_loss && winnings.negative?
      self.least_loss = winnings
    end

  end

  def match_summary
    '%s, $%s, $%s, $%s, $%s, $%s, $%s, $%s, %s, %s, %s, %s, %s' % 
    [name, starting_money, total_bets, total_winnings, lowest_win, highest_win, greatest_loss, least_loss, type_regularity[:even], type_regularity[:odd], type_regularity[:one_die], type_regularity[:both_dice], type_regularity[:difference]]
  end
end

class Player
  # include Logger

  attr_accessor :name, :money, :bet, :guess, :won_round, :winnings, :total_wins, 
                :rounds, :streak, :round_min, :round_max

  def initialize(name, money: 50)
    self.name = name
    self.money = money
    self.winnings = 0
    self.bet = 0

    self.total_wins = 0
    self.rounds = 0

    self.round_min = 1
    self.round_max = money

    self.streak = '......'    
    # self.match_record = [name] #name::match no, starting cash, total bets, total winnings


    # clear_log
  end

  def predict
  end

  def wager
  end

  def won?
    won_round
  end

  def make_money?
    winnings.positive?
  end

  def lost_game?
    money < round_min
  end

  def finish_round
    # log_round

    self.streak = streak[1...6]

    if won?
      self.total_wins += 1 
      self.streak += "+"
    else
      self.streak += "-"
    end

    self.rounds += 1
    self.money += winnings
  end

  def finish_match
    # match_record << [@match_no, starting_money, total_bets, total_winnings]
    # clear_log
  end

  def type
    GuessReader.infer_type guess
  end

  def convert_cash_to_string(cash)
    case cash.abs.to_s.length
    when ..3
      '$%s' % cash
    when 4..6
      hundreds = cash.to_s[-3..]
      thousands = cash.to_s[..-4]

      '$%s,%s' % [thousands, hundreds]
    when 7..9
      '$%s Mil.' % cash.to_s[..-7]
    when 10..12
      '$%s Bil.' % cash.to_s[..-10]
    else
      "$#{cash}"
    end
  rescue
    puts cash
  end

  def betting_range
    if round_min > [round_min, money, round_max].min
      puts "#{name}'s round min of #{round_min} greater than #{round_max} or #{money_string}"
    end
    round_min..[money, round_max].min
  end

  def money_string
    convert_cash_to_string(money)
  end

  def winnings_string
    convert_cash_to_string(winnings)
  end

  def bet_string
    convert_cash_to_string(bet)
  end

end

