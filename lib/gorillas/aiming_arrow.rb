module Gorillas
  class AimingArrow < SimpleDelegator
    def initialize
      __setobj__(Gosu::Image.new("media/arrow_45.png"))
    end

    def draw_scaled_and_rotated(x, y, angle_in_rad, mouse_x, mouse_y, *args)
      diff_x = mouse_x - x
      diff_y = mouse_y - y
      scale_x = if diff_x.abs > 1
        diff_x / width
      else
        1
      end
      scale_y = if diff_y.abs > 1
        diff_y / height
      else
        1
      end
      __getobj__.draw_rot(
        x,
        y,
        ZOrder::AimingArrow,
        to_degrees(angle_in_rad),
        0.5,
        0.5,
        scale_x, scale_y,
        *args
      )
    end

    def draw_rot(x, y, angle_in_rad, *args)
      __getobj__.draw_rot(x, y, ZOrder::AimingArrow, to_degrees(angle_in_rad), *args)
    end

    private

    def to_degrees(angle)
      Gosu.radians_to_degrees(angle)
    end
  end
end
