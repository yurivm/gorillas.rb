module Gorillas
  class Sprite
    attr_reader :coordinates

    def initialize(coordinates)
      @coordinates = coordinates.clone
    end

    def draw
      image.draw(x, y, z_order)
    end

    def x
      coordinates.x
    end

    def x2
      coordinates.x
    end

    def y
      coordinates.y
    end

    def y2
      coordinates.y
    end

    def bounding_box
      BoundingBox.new(x, y, x2, y2)
    end

    protected

    def image
      fail "not implemented in the base class!"
    end

    def z_order
      ZOrder::BACKGROUND
    end
  end
end
