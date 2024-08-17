# frozen_string_literal: true

require_relative 'screen'

class StartScreen < Screen

  class << self
    def to_h
      {
        author: "Saramir",
        title: "Hen Chō Han",
        subtitle: "編丁半"
      }
    end

    def screen
      [
        '%<title>s',
        '%<subtitle>s',
        'by %<author>s'
      ].map do |line|
        (line % to_h).center(`tput cols`.to_i)
      end.join("\n")
    end
  end
end
