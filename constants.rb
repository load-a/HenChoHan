class Numeric
  def round_up(increment = 10)
    return self if (self % increment).zero?

    self + increment - (self % increment)
  end

  def round_down(increment = 10)
    return self if (self % increment).zero?

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

  def parent
    self.superclass
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
