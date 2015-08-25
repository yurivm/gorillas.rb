module Gorillas
  class Gorilla
    SPRITE_SIZE = 34

    attr_reader :x, :y

    def initialize(x:, y:)
      @image = Gosu::Image.new("media/gorilla_32.png")
      @x = x
      @y = y
    end

    def draw
      @image.draw(@x, @y, 1)
    end

    def put_on_top_of_house(house)
      @x = house.x + (house.x2 - house.x) / 2
      @y = house.y - SPRITE_SIZE
    end
  end
end
