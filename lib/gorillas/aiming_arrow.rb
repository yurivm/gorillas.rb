module Gorillas
  class AimingArrow
    def initialize
      @image = Gosu::Image.new("media/arrow_100.png")
    end

    def draw_rot(x, y, angle, *args)
      @image.draw_rot(x, y, ZOrder::AimingArrow, to_degrees(angle), *args)
    end

    def to_degrees(angle)
      Gosu.radians_to_degrees(angle)
    end
  end
end
