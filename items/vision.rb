# frozen_string_literal: true

require_relative 'item'

class Vision < Item # or Item? Since non-trick items can also have future vision?
  @type = :vision
end

class Coattails < Vison
end

class Foresight < Vision
end

class Reroll < Vision

end
