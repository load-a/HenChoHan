# frozen_string_literal: true

class Item

  @name = 'Item'
  @base_price = 100
  @type = :item
  @description = 'Is an Item.'

  @destroy = false

  class << self
    attr_accessor :name, :base_price, :description, :type, :destroy

    def price(multiplier = 1)
      base_price * multiplier
    end

    def to_s(price_multiplier = 1)
      [
        '%s $%i' % [name, price(price_multiplier)],
        Rainbow('(%s)' % type).italic,
        '%s' % description
      ]
    end

    def stats
      {
        name: name,
        description: description,
        price: price,
        type: type
      }
    end

    def pick_die(message = "Use on which die: ")
      puts message + Dealer.dice.to_s
      replace = gets.chomp.to_i

      case replace
      when 1
        replace = :die_1
      when 2
        replace = :die_2
      else
        replace = :skip
      end

      replace
    end

    def destroy?
      @destroy
    end
  end

  def destroy
    this.destroy = true
  end

  def destroy?
    this.destroy
  end
end


# Item Ideas

# Tricks (persistent/reusable)
# - Heavy Dice
# - Light Dice
# - Even Dice
# - Odd Dice
# - Weights (random?)
# - Coattails (see winner)
# - Foresight (see result)
# - Other People's Property (steal winnings)
# - White Elephant (steal guess)
# - Reroll (reroll a bad guess)
# - Shop Around (reroll shop items)

# Abilities (consumable)
# - Savings (recover from bottoming out; put money aside for this?)
# - Investment (win a little every time a certain guess is correct)
# - Fashionably Late (Get extra round to make Elite)
# - Subscription Service (stay Elite but lose money every round you do)
# - Double Down (Make two guesses; they can be the same for double the winnings)
# - Win Sum (Able to bet on the sum of the dice: payout bonus based on rarity)
# - Streaking (Winnings--and loses--multiplied by streak bar wins + 1)
# - Death Warp (make it to the next round after bottoming out)
# - Charisma Save (make dice match guess)
# - See the Difference (see the difference of the next roll)

# Lucky Rolls (these double your money or winnings; whichever is bigger) 
#     note: add guess and roll to an array and compare with other arrays
# - BlackJack (guess and roll 2 & 1)
# - Hail Santa (guess 1 & 2 and roll 2 & 5, or the other way around)
# - Devil's Dice (guess 6 and roll 6 & 6)
# - Lucky 13 (guess and roll 1 & 3)
# - Company (guess 2 and roll 2 & 2)
# - Society (guess 3 and roll 3 & 3)
# - Nice (guess 3 & 3 and roll 6 & 3, or other way around)
# - Critical Fail (guess 1 & 1 and roll 1 & 1)
# - Obligatory (guess 1 & 2 and roll 3 & 4)
# - Lucky 4 (guess 4 & 4 and roll 4 & 4)

# Curses (useful bu has a risk or chance of backfiring) -- created whenever someone has a full losing streak?
# - Distribution of Wealth (one player's money is split among the other players)
# - Spite (reroll on a good guess)
# - Frozen Assets (earn/lose no money this round)
# - NFT Bust (lose all savings/investments)
# - Encore (must repeat guess and bet)
# - Equalizer (all players' money matches certain player's money)
# - Go Big or Go Home (must bet the maximum)
# - Lightning (all players'--except one--have their money set to previous par)
# - Open Windows (the elite window increases)
# - Community Chest (all players--except one--have their money become the average of the entire roster's money)
# - Paid in Advance (get paid a lot of money but earn nothing until it's repaid)
# - Revolution (when quota is met, all Elite players lose money equal to par and the game continues)
# - 
