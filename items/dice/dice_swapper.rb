module DiceSwapper
  attr_accessor :number

  def use
    super

    selection = pick_die

    return puts 'Use cancelled.' if selection == :skip

    if is_a? Weight
      Dealer.send("#{selection}=", (Dealer.send(selection.to_s).dup << number).flatten)
    else
      Dealer.send("#{selection}=", number)
    end
  end

  def pick_die(message = 'Use on which die: ')
    puts message + Dealer.dice.to_s
    replace = gets.chomp.to_i

    case replace
    when 1
      :die_1
    when 2
      :die_2
    else
      :skip
    end
  end
end
