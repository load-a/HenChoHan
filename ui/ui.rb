# frozen_string_literal: true

require 'rainbow'

module UI
  module_function

  def clear_screen
    system "printf '\33c\e[3J'"
  end

  def divider(length, character: '_')
    character * length
  end

  def convert_int_to_money(int)
    int_string = int.to_s
    abs_string = int.abs.to_s

    case abs_string.length
    when ..3
      '$%s' % int
    when 4..6
      hundreds = int_string[-3..]
      thousands = int_string[..-4]
      '$%s,%s' % [thousands, hundreds]
    when 7..9
      '$%s Mil.' % int_string[..-7]
    when 10..12
      '$%s Bil.' % int_string[..-10]
    else
      "$#{int}"
    end
  end
end
