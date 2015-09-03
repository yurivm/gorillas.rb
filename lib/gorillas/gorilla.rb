module Gorillas
  class Gorilla
    attr_reader :x, :y

    def initialize(x:, y:)
      @image = Gosu::Image.new("media/gorilla_32.png")
      @x = x
      @y = y
    end

    def draw
      @image.draw(@x, @y, ZOrder::Gorillas)
    end

    def put_on_top_of_house(house)
      @x = house.x + (house.x2 - house.x) / 2
      @y = house.y - @image.height
    end
  end
end
