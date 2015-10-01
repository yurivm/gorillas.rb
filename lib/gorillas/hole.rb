# inspired by https://gist.github.com/jlnr/661266
module Gorillas
  class Hole
    IMAGE = Gosu::Image.new("media/hole_16.png")

    def initialize(coordinates)
      @coordinates = coordinates.clone
    end

    def image
      IMAGE
    end

    def x
      coordinates.x
    end

    def y
      coordinates.y
    end

    def draw
      image.draw_rot(x, y, ZOrder::Holes, 0)
    end

    private

    attr_reader :coordinates
  end
end
