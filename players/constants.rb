# frozen_string_literal: true

# Names have a 15 character limit
SPECIAL_NAMES = %w[
  Alyssa
  Haramatsu
  Kori
  Leif
  Niamh
  Xia
  Yumi

  JJ
  Rae
  Mel
].freeze

MULTI_WORD_NAMES = [
  'Big G',
  'Real Eyes',
  'Real Lies',
  'Old Mack',
  'New Mack',
  'Mr. Maxwell Out',
  'Trips Tanaka',
  'Choco Giddy-up'
].freeze

NPC_NAMES = %w[
  Ainsley
  Alanna
  Anderson
  Arielle
  Armani
  Aubrey
  Cara
  Carla
  Cassius
  Clinton
  Danielle
  Ethan
  Felicity
  Giovanni
  Goose
  Gretchen
  Hayden
  Jamal
  Jeffery
  Josephine
  Kitty
  Lillian
  Lion
  Luigi
  Manatee
  Marcos
  Marlon
  Mary
  Michaela
  Mimi
  Nadia
  Penelope
  Quinton
  Realize
  Ramon
  Reagan
  Rhett
  Rita
  Ross
  Rowan
  Sean
  T-Dog
  Tripp
  Vanessa
  Velvet
  Yasmin
  Zack
  Zelda
] + SPECIAL_NAMES + MULTI_WORD_NAMES
