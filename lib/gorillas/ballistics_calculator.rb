module Gorillas
  class BallisticsCalculator

    attr_reader :angle, :velocity

    def initialize
      reset!
    end

    def set_initial_values(gorilla_coordinates, mouse_coordinates)
      @gorilla_coordinates = gorilla_coordinates
      @mouse_coordinates = mouse_coordinates
    end

    def calculate_params
      @angle = calculate_angle
      @velocity = calculate_velocity
    end

    def reset!
      @angle = 0
      @velocity = Velocity.new(0, 0)
    end

    private

    attr_reader :mouse_coordinates, :gorilla_coordinates

    # mouse coordinates in a coordinate system where gorilla's position is at (0, 0)
    def x2
      mouse_coordinates.x - gorilla_coordinates.x
    end

    # mouse coordinates in a coordinate system where gorilla's position is at (0, 0)
    def y2
      mouse_coordinates.y - gorilla_coordinates.y
    end

    def calculate_angle
      Math.atan2(y2, x2)
    end

    def calculate_velocity
      Velocity.new(x2, y2)
    end
  end
end
