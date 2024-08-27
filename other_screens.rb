module OtherScreens
  def preview_first_round
    puts RoundPreview.screen(Roster.npcs.sort_by(&:name)) if Dealer.first_round?
  end

  # Changes control flow if the player inputs an optional keyword.
  # @return [Void]
  def redirect_optional_inputs
    case human.guess
    when 'i', 'item', 'items', 'u', 'use'
      manage_inventory
    when 's', 'see'
      preview_round
    when 'r', 'rules'
      system 'cat user_interface/rules.txt'
    when 'p', 'previous', 'last', 'l'
      puts previous_round unless Dealer.start_of_game?
    when 'd', 'dealer'
      puts DealerStatus.screen
    when 'm', 'me'
      print "\nYour Stats: "
      print format('%s %s %s', human.name, UserInterface.convert_integer_to_money(human.money), human.streak)
      puts "\n\n"
    end
  end

  def preview_round
    puts RoundPreview.screen(Roster.npcs.sort_by(&:name))
  end

  def manage_inventory
    show_inventory
    return if human.inventory.empty?

    return unless Input.query 'Use an item?'

    puts 'No uses left.' if human.inventory.none? { |item| item.uses_left.positive? }
    select_inventory
  end

  def show_inventory
    if human.inventory.empty?
      puts 'No items.'
    else
      puts Inventory.screen human.inventory
    end
  end

  def select_inventory
    if human.inventory.none? { |item| item.uses_left.positive? }
      puts 'No items are usable.'
    elsif human.inventory.one? { |item| item.uses_left.positive? }
      only_usable_item = human.inventory.find { |item| item.uses_left.positive? }
      human.use(only_usable_item)
    else
      selected_item = Input.menu_select(human.inventory, 'Which one?')
      return if selected_item.nil?
      return puts "#{selected_item.name} is out of uses." if selected_item.uses_left.zero?

      human.use selected_item
    end
  end

  def open_store
    puts "You're moving on!#{Rainbow(' (Press Enter to continue.)').faint}"

    Input.continue

    Store.new.open_for_business
  end
end
