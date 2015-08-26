module Gorillas
  class AimingArrow
    def initialize
      @image = Gosu::Image.new("media/arrow_45.png")
    end

    def draw_rot(x, y, angle_in_rad, *args)
      @image.draw_rot(x, y, ZOrder::AimingArrow, to_degrees(angle_in_rad), *args)
    end

    def to_degrees(angle)
      Gosu.radians_to_degrees(angle)
    end
  end
end
