module FinishingRound
  def finish_round
    determine_winners

    Bank.settle_up Roster.all

    human.use_final_inventory

    Roster.conclude_round

    Scorer.assign_elites Roster.all

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

      Input.await_valid_input 'Odd or Even?' do |_answer, _type, this|
        if this.back? || this.no?
          Input.query 'End the challenge?'
          break if this.yes?
        end
        Input.type == :normal
      end

      if Input.yes?
        human.money += human.winnings
        human.streak = '......'
        puts 'Nice job!'
        break
      end

      HumanPlayer.guess = Input.answer

      Scorer.determine_round_win(human)

      if human.won?
        human.winnings *= 2
        puts "Your winnings double! (#{UserInterface.convert_integer_to_money(human.winnings)})"
        limit -= 1
      else
        puts 'You lost all your winnings.'
        human.streak = '......'
        human.winnings = 0
        break
      end
    end
  end

  def summarize_round
    puts previous_round
  end
end
