module ItemFunction

  attr_accessor :name, :level, :type, :item_description, :type_description,
                :price_percent, :uses_left

  def stats
    traits = instance_variables.each_with_object({}) do |attribute_name, status|
      status[attribute_name[1..].to_sym] = instance_variable_get(attribute_name)
    end

    traits.merge({ price: price, description: description, uses: uses })
  end

  def price
    price_percent * Scorer.par
  end

  def description
    "#{item_description}\n#{type_description}"
  end

  def use
    self.uses_left -= 1
  end

  def reset
    self.uses_left = level
  end

  alias uses level
end
