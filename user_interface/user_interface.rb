# frozen_string_literal: true

require 'rainbow'

module IntegerStringFormatting

  # @todo This method is a mess.
  def convert_integer_to_money(integer_string)
    integer_string = integer_string.to_s if integer_string.is_a?(Integer)
    negative = integer_string.to_i.negative?

    integer_string = integer_string.sub('-', '')
    absolute_value = integer_string.length % 3 == 2 ? integer_string[..4] : integer_string[..5]

    case absolute_value.length
    when 1..3
      "#{'-' if negative}$#{integer_string}"
    when 4..6
      least_sig = absolute_value.chars[-3..]
      most_sig = absolute_value.chars[...-3]
      "#{'-' if negative}$#{most_sig.join}.#{least_sig.join}#{get_magnitude(integer_string.to_i)}"
    end
  end

  def get_magnitude(integer)
    case integer.abs
    when 0...1_000 then ''
    when 1_000...1_000_000 then 'k'
    when 1_000_000...1_000_000_000 then 'm'
    when 1_000_000_000...1_000_000_000_000 then 'b'
    when 1_000_000_000...1_000_000_000_000_000 then 't'
    else
      'x'
    end
  end
end

# Handle text and screen elements
module UserInterface
  extend IntegerStringFormatting

  module_function

  def clear_screen
    system 'clear'
  end

  def blank_feed
    system "printf '\33c\e[3J'"
  end

  def divider(length = 80, character = '_')
    character * length
  end
end
