# frozen_string_literal: true

require_relative 'item'

class Weight < Item
  @name = "Weight"
  @price_percent = 1.0
  @type = :consumable

  attr_accessor :name, :number, :description, :price_percent, :uses, :uses_left,
                :level

  def initialize(number = rand(1..6))
    self.name = self.class.name
    self.number = number
    self.description = "Increases the likelihood of rolling a #{number}."
    self.price_percent = self.class.price_percent
    self.level = 1
    self.uses_left = 1
  end

  def price
    price_percent * Scorer.par
  end

  def use(which_die)
    altered_die = Dealer.send(which_die).dup << number
    Dealer.send("#{which_die}=", altered_die)
  end

  def stats
    {
      name: name,
      description: description,
      price: price,
      type: type,
      level:level,
      uses: uses,
      uses_left: uses_left
    }
  end

  def use
    selection = this.pick_die

    return puts "Use cancelled." if selection == :skip

    this.destroy = true

    Dealer.send("#{selection}=", Dealer.send("#{selection}").dup << number)
  end

  def type
    @type
  end
end
