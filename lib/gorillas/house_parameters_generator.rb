module Gorillas
  module HouseParametersGenerator
    MIN_HOUSE_WIDTH = 64
    MIN_HOUSE_HEIGHT = 128

    COLORS = [
      [168, 168, 168],
      [0, 168, 168],
      [168, 0, 0]
      # [ 168, 0, 168],
      # [ 168, 168, 0]
    ]
    def self.random_house_width
      MIN_HOUSE_WIDTH + (16 * rand(10))
    end

    def self.random_house_height
      MIN_HOUSE_HEIGHT + (16 * rand(25))
    end

    def self.random_color
      index = rand(COLORS.count)
      color = [255] + COLORS[index]
      Gosu::Color.new(*color)
    end
  end
end
