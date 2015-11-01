module Gorillas
  class ProjectileCalculator
    attr_reader :angle, :velocity

    def initialize
      reset!
    end

    def set_values(gorilla_coordinates, mouse_coordinates)
      reset!
      @gorilla_coordinates = gorilla_coordinates
      @mouse_coordinates = mouse_coordinates
    end

    def calculate_params
      @angle = calculate_angle
      @velocity = calculate_velocity
      @coordinates_at_screen_height = calculate_coordinates_at_screen_height
    end

    def reset!
      @angle = 0
      @landing_time = nil
      @coordinates_at_screen_height = nil
      @velocity = Velocity.new(0, 0)
    end

    def lands_offscreen?
      @coordinates_at_screen_height.x_offscreen?
    end

    def delta_x(delta_t)
      # we have projections already, no need for sin/cos
      velocity.x * delta_t
    end

    def delta_y(delta_t)
      # we have projections already, no need for sin/cos
      velocity.y * delta_t - (acceleration * delta_t * delta_t / 2)
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


    def calculate_coordinates_at_screen_height
      Coordinates.new(
        gorilla_coordinates.x + delta_x(landing_time),
        GameWindow::SCREEN_HEIGHT
      )
    end

    def acceleration
      Gorillas.configuration.acceleration
    end

    def landing_time
      @landing_time ||= (velocity.y - Math.sqrt(velocity.y * velocity.y - 2 * acceleration * GameWindow::SCREEN_HEIGHT)) / acceleration
    end
  end
end
