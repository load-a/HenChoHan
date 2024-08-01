# frozen_string_literal: true

require_relative 'item'

class Weight < Item
  @name = "Weight"
  @base_price = 100
  @type = :consumable

  attr_writer :name, :number, :description, :base_price

  def initialize(number = rand(1..6))
    self.name = self.class.name
    self.number = number
    self.description = "Increases the likelihood of rolling a #{number}."
    self.base_price = self.class.base_price
  end

  public

  attr_reader :name, :number, :description, :base_price

  def price(mult = 1)
    base_price * mult
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
      type: type
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
