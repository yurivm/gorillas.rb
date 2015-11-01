module Gorillas
  class AimingArrow < SimpleDelegator
    def initialize
      __setobj__(Gosu::Image.new(Gorillas.configuration.arrow_image_file))
    end

    def draw_scaled_and_rotated(coordinates, angle_in_rad, mouse_coordinates, *args)
      @diff_x = (mouse_coordinates.x - coordinates.x).abs
      @diff_y = (mouse_coordinates.y - coordinates.y).abs
      # normalize
      __getobj__.draw_rot(
        coordinates.x,
        coordinates.y,
        ZOrder::AIMING_ARROW,
        to_degrees(angle_in_rad),
        0.5,
        0.5,
        scale_x, scale_y,
        *args
      )
    end

    private

    attr_reader :diff_x, :diff_y

    def scale_x
      diff_x > width ? diff_x / width : 1.0
    end

    def scale_y
      diff_y > height ? diff_y / height : 1.0
    end

    def to_degrees(angle)
      Gosu.radians_to_degrees(angle)
    end
  end
end
