# frozen_string_literal: true

module NPCBehavior

  TEMPERMENTS = {
    timid: {
      normal: 17,
      one_die: 3,
      both_dice: 0,
      difference: 0,
    },
    risky: {
      normal: 1,
      one_die: 10,
      both_dice: 4,
      difference: 5,
    },
    safe: {
      normal: 12,
      one_die: 6,
      both_dice: 1,
      difference: 1,
    },
    variable: {
      normal: 5,
      one_die: 5,
      both_dice: 5,
      difference: 5,
    },
  }

  BETTING_STYLES = {
    safe: {
      upper_limit: 0.15,
      lower_limit: 0.1,
      quit_limit: 5
    },
    risky: {
      upper_limit: 0.50,
      lower_limit: 0.30,
      quit_limit: 2
    }
  }

  attr_accessor :temperment, :guess_style, :temperment_name, :betting_style,
                :betting_style_name

  def assign_temperment
    self.temperment_name = TEMPERMENTS.keys.sample
    self.temperment = TEMPERMENTS[temperment_name]
  end

  def assign_guess_style
    self.guess_style = []

    temperment.each do |style, probability|
      probability.times do 
        self.guess_style << style
      end
    end
  end

  def assign_betting_style
    self.betting_style_name = BETTING_STYLES.keys.sample
    self.betting_style = BETTING_STYLES[betting_style_name]
  end

  def initialize_behavior
    assign_temperment
    assign_guess_style
    assign_betting_style
  end
end
