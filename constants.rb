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

  def not_positive?
    self <= 0
  end

  def not_negative?
    self >= 0
  end
end

class Object
  def this
    self.class
  end
end

class String
  def is_numeric?
    return false unless %w[- 1 2 3 4 5 6 7 8 9 0].include? self[0]

    self.to_i.to_s == self ||
    self.to_f.to_s == self ||
    if self.start_with? '-'
      self.to_i(2).to_s(2).sub('-', '-0b') == self ||
      self.to_i(8).to_s(8).sub('-', '-0') == self ||
      self.to_i(16).to_s(16).sub('-', '-0x') == self
    else
      "0b" + self.to_i(2).to_s(2) == self ||
      "0" + self.to_i(8).to_s(8) == self ||
      "0x" + self.to_i(16).to_s(16) == self
    end
  end
end
