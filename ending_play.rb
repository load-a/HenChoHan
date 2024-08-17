module EndingPlay
  def end_game(message = 'You ran out of money.')
    puts message, 'You lose.'
    @break = true
  end

  def end_match
    puts 'Match Over!'

    Roster.all.each do |player|
      Scorer.determine_match_win player
    end

    if human.won_match?
      open_store

      setup_next_match
    else
      end_game "You didn't make Elite."
    end
  end

  def setup_next_match
    Dealer.next_match

    Scorer.par *= 3

    Roster.all.each do |player|
      player.money = Bank.starting_money
    end

    human.inventory.each do |item|
      item.reset if item.respond_to? 'reset'
    end
  end
end
