# frozen_string_literal: true

EVEN = %w[c cho e even].freeze
ODD = %w[h han o odd].freeze
DIE = %w[1 2 3 4 5 6].freeze
SUM = %w[2 3 4 5 6 7 8 9 10 11 12].freeze
DIFFERENCE = %w[0 -1 -2 -3 -4 -5].freeze

QUIT = %w[q quit stop done exit end fin finish やめて].freeze

ANSWER = {
  affirmative: %w[1 y yes はい そう indeed ok sure yeah yea yup fine],
  negative: %w[0 n no ない 違う いいえ nah nope]
}.freeze

BACK = %w[back b return undo].freeze

OPTION = {
  item: %w[i item items inventory use u],
  information: %w[s status stats see me m r rules d dealer p previous l last]
}.freeze

NORMAL = EVEN + ODD
SPECIAL = DIE + SUM + DIFFERENCE

PLAY = {
  normal: NORMAL,
  special: SPECIAL
}.freeze

GUESS = {
  even: EVEN,
  odd: ODD,
  die: DIE,
  sum: SUM,

  difference: DIFFERENCE
}.freeze
