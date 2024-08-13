# frozen_string_literal: true

require 'rainbow'

module UI
  module_function

  def clear_screen
    system 'clear'
  end

  def blank_feed
    system "printf '\33c\e[3J'"
  end

  def divider(length, character = '_')
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

  def menu_select(options, prompt = 'Make a selection:')
    puts prompt + ' ' + Rainbow("(name or number)").faint
    pick = gets.downcase.chomp

    exit_on_quit pick

    selection = options.select do |option| 
      pick == option.name.downcase || 
      pick.to_i == options.index(option) + 1 
    end

    selection[0]
  end

  def query(prompt = "Are you sure?")
    puts prompt
    answer = gets.chomp
    exit_on_quit answer
    YES.include? answer
  end
  alias ask query
  alias confirm query

  def continue
    _continue = gets
  end

  def exit_on_quit(input)
    exit if QUIT.include? input
  end
end
