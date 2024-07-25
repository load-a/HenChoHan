# frozen_string_literal: true

require 'rainbow'

class Screen

  attr_accessor :contents

  def initialize(*content_keys)
    self.contents = Hash.new(0)

    content_keys.each do |content_key|
      self.contents[content_key] = nil
    end

  end

  def to_s
    contents.to_s
  end

  def [] this
    contents[this]
  end

  def []= this, that
    self.contents[this] = that
  end

end
