module Gorillas
  class AimingArrow < SimpleDelegator
    def initialize
      __setobj__(Gosu::Image.new(Gorillas.configuration.arrow_image_file))
    end

    def draw_scaled_and_rotated(x, y, angle_in_rad, mouse_x, mouse_y, *args)
      diff_x = (mouse_x - x).abs
      diff_y = (mouse_y - y).abs
      # normalize
      scale_x = diff_x > width ? diff_x / width : 1.0
      scale_y = diff_y > height ? diff_y / height : 1.0
      __getobj__.draw_rot(
        x,
        y,
        ZOrder::AIMING_ARROW,
        to_degrees(angle_in_rad),
        0.5,
        0.5,
        scale_x, scale_y,
        *args
      )
    end

    private

    def to_degrees(angle)
      Gosu.radians_to_degrees(angle)
    end
  end
end
