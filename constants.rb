QUIT = %w[q quit stop done exit end fin finish yameru]
OPTIONS = %w[n new t tricks r rules s see]

EVEN = %w[c cho e even]
ODD = %w[h han o odd]
DIE = %w[1 2 3 4 5 6]
NUMBER = %w[2 3 4 5 6 7 8 9 10 11 12]
DIFFERENCE = %w[0 -1 -2 -3 -4 -5]

VALID_GUESS = EVEN + ODD + DIE + NUMBER + DIFFERENCE
VALID_INPUT = VALID_GUESS + QUIT + OPTIONS

class Numeric
  def round_up(increment = 10)
    return self if self % increment == 0
    self + increment - (self % increment)
  end

  def round_down(increment = 10)
    return self if self % increment == 0
    self - (self % increment)
  end
end
