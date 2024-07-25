# frozen_string_literal: true

require_relative 'screen'

START_SCREEN = Screen.new(:author, :title, :subtitle)

START_SCREEN.contents = {
  author: "Saramir",
  title: "Hen Chō Han",
  subtitle: "編丁半"
}

def START_SCREEN.to_s
  [
    '%<title>s',
    '%<subtitle>s',
    'by %<author>s'
  ].map do |line|
    (line % contents).center(`tput cols`.to_i)
  end.join("\n")
end
