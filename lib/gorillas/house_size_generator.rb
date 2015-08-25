module Gorillas
  module HouseSizeGenerator
    def self.random_house_width
      GameWindow::SCREEN_WIDTH / GameWindow::HOUSES_COUNT
    end

    def self.random_house_height
      # not smaller than /10 plus some random number
      GameWindow::SCREEN_HEIGHT / 5 + rand(GameWindow::SCREEN_HEIGHT / 2)
    end

    def self.random_color_byte
      rand(255)
    end

    def self.random_color
      Gosu::Color.new(
        255,
        random_color_byte,
        random_color_byte,
        random_color_byte
      )
    end
  end
end
