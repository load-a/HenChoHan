module FinishingRound
  def finish_round
    determine_winners

    Bank.settle_up Roster.all

    challenge_the_house if human.streak[1..] == '+++++' && human.won?

    Roster.conclude_round

    Scorer.determine_elites Roster.all

    self.previous_round = RoundSummary.screen(Roster.all.sort_by(&:money).reverse)
    summarize_round
  end

  def determine_winners
    Roster.all.each do |player|
      Scorer.determine_round_win(player)
    end
  end

  def challenge_the_house
    puts "You're on a hot streak!"
    return unless Input.query 'Would you like to Challenge the House?'

    play_the_house(5)
  end

  def play_the_house(limit)
    loop do
      break puts 'Congratulations!' if limit.zero?

      Dealer.roll
      human.predict

      unless Input::NORMAL.include? human.guess
        break if Input.query 'Do you want to end the challenge?'

        next
      end

      Scorer.determine_round_win(human)

      if human.won?
        puts "Your winnings double! (#{UserInterface.convert_integer_to_money(human.winnings)})"
        human.winnings *= 2
        limit -= 1
        break puts 'Good run!' unless Input.query('Do you want to continue?')
      else
        human.winnings = 0
        break puts 'You lost all your winnings.'
      end
    end
  end

  def summarize_round
    puts previous_round
  end
end
