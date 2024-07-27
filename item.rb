# frozen_string_literal: true

class Item

  @name = 'Item'
  @base_price = 100
  @type = :item
  @description = 'Is an Item.'

  class << self
    attr_accessor :name, :base_price, :description, :type

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
  end
end

class Trick < Item
  @@type = :trick

  def self.type
    @@type
  end

  def type
    @@type
  end
end


class SwapDie < Trick
  NUMBERS = [0]
  @@description = "\nSwap out one of the Dealer\'s dice for this."

  class << self

    def description
      @description + @@description
    end

    def use(switch)
      Dealer.send("#{switch}=", self::NUMBERS) 
    end
  end
end

class EvenDie < SwapDie

  NUMBERS = [2, 4, 6]

  @name = 'Even Dice'
  @base_price = 200
  @description = 'A die with only even numbers.'
end

class OddDie < SwapDie

  NUMBERS = [1, 3, 5]

  @name = 'Odd Dice'
  @base_price = 200
  @description = 'A die with only odd numbers.'
end

class LightDie < SwapDie

  NUMBERS = [1, 2, 3]

  @name = 'Light Dice'
  @base_price = 200
  @description = 'A die with the numbers 1, 2 and 3.'
end

class HeavyDie < SwapDie

  NUMBERS = [4, 5, 6]

  @name = 'Heavy Dice'
  @base_price = 200
  @description = 'A die with the numbers 4, 5, and 6.'
end

class Weight < Trick
  @name = "Weight"
  @base_price = 250

  attr_writer :name, :number

  def initialize(number = rand(1..6))
    self.name = self.class.name
    self.number = number
  end

  public

  attr_reader :name, :number

  def base_price
    self.class.base_price
  end

  def use(which_die)
    altered_die = Dealer.send(which_die).dup << number
    Dealer.send("#{which_die}=", altered_die)
  end

  def type
    @@type
  end
end


class Vision < Trick # or Item? Since non-trick items can also have future vision?
end

class Coattails < Vison
end

class Foresight < Vision
end

class Reroll < Vision
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
