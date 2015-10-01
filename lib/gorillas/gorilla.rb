module Gorillas
  class Gorilla
    attr_reader :coordinates
    attr_reader :x, :y

    def initialize(x:, y:)
      @image = Gosu::Image.new("media/gorilla_32.png")
      @coordinates = Coordinates.new(x, y)
    end

    def x
      coordinates.x
    end

    def y
      coordinates.y
    end

    def draw
      @image.draw(x, y, ZOrder::Gorillas)
    end

    def bounding_box
      @bounding_box ||= create_bounding_box
    end

    def put_on_top_of_house(house)
      coordinates.x = house.x + (house.x2 - house.x) / 2
      coordinates.y = house.y - @image.height
      create_bounding_box
    end

    private

    attr_reader :image

    def create_bounding_box
      BoundingBox.new(x, y, x + image.width, y + image.height)
    end
  end
end
