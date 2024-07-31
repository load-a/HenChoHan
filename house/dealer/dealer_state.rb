# frozen_string_literal: true

module DealerState
  def even?
    result.sum.even?
  end

  def odd? 
    result.sum.odd?
  end

  def state
    even? ? :even : :odd
  end

  def difference
    (result[0] - result[1]).abs
  end

  def correct_guesses
    [
      state,
      result[0],
      result[1],
      result,
      -difference
    ]
  end

  def first_round?
    round == 1
  end
end
