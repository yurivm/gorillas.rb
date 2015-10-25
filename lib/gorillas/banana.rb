module Gorillas
  class Banana
    ACCELERATION = -9.81

    attr_reader :coordinates, :object_hit

    def initialize(x: 0, y: 0, adjust_y: true)
      @coordinates = Coordinates.new(x, y)
      @start_time = 0
      @image = Gosu::Image.new(Gorillas.configuration.banana_image_file)
      @image_angle = 0
      @landing_time = 0
      @landing_coordinates = Coordinates.new(0, 0)
      @object_hit = nil
      @adjust_y = adjust_y
    end

    def set_starting_conditions(coordinates:, velocity:, time:)
      adjusted = coordinates.clone
      adjusted.y -= image.height if adjust_y?
      @starting_coordinates = adjusted.clone
      @coordinates = adjusted.clone
      @velocity = velocity
      @start_time = time
      @landing_time = set_landing_time
      @landing_coordinates = set_landing_coordinates
      @image_angle = 0
      @object_hit = nil
    end

    def update_position(time_elapsed)
      delta_t = (time_elapsed - start_time) / 1000.0
      return if delta_t < 0
      set_image_angle(time_elapsed)
      coordinates.x = starting_coordinates.x + delta_x(delta_t)
      coordinates.y = starting_coordinates.y + delta_y(delta_t)
    end

    def x
      coordinates.x
    end

    def y
      coordinates.y
    end

    def explosion_coordinates
      Coordinates.new(x + x_bb_offset, y + y_bb_offset)
    end

    def bounding_box
      BoundingBox.new(
        x + x_bb_offset,
        y + y_bb_offset,
        x + x_bb_offset + 4,
        y + y_bb_offset + 4
      )
    end

    def draw
      @image.draw_rot(
        coordinates.x,
        coordinates.y,
        ZOrder::BANANA,
        image_angle
        )
    end

    def hits_houses?(houses)
      hits?(houses)
    end

    def hits_gorillas?(gorillas)
      hits?(gorillas)
    end

    def hits_sun?(sun)
      hits?([sun])
    end

    def offscreen_and_will_not_return?
      lands_offscreen? && offscreen?
    end

    def to_s
      "#{format('%2.2f', x)} #{format('%2.2f', y)}"
    end

    private

    def adjust_y?
      @adjust_y
    end

    def x_bb_offset
      @x_bb_offset ||= image.width / 2
    end

    def y_bb_offset
      @y_bb_offset ||= image.height / 2
    end

    def hits?(collection)
      # TODO: this gets called twice. make sure it works as expected
      collection.detect do |object|
        if intersects_with?(object)
          @object_hit = object
          true
        end
      end
    end

    def intersects_with?(another_object)
      this_bb = bounding_box
      another_bb = another_object.bounding_box
      # a great illustration of this condition: http://silentmatt.com/rectangle-intersection/
      this_bb.x1 < another_bb.x2 && this_bb.x2 > another_bb.x1 && this_bb.y1 < another_bb.y2 && this_bb.y2 > another_bb.y1
    end

    attr_reader :velocity, :image, :image_angle, :start_time, :landing_time, :landing_coordinates, :starting_coordinates

    def offscreen?
      coordinates.offscreen?
    end

    def lands_offscreen?
      landing_coordinates.x_offscreen?
    end

    def move_starting_position_upwards!
      @coordinates.y -= image.height
    end

    def delta_x(delta_t)
      # we have projections already, no need for sin/cos
      velocity.x * delta_t
    end

    def delta_y(delta_t)
      # we have projections already, no need for sin/cos
      velocity.y * delta_t - (ACCELERATION * delta_t * delta_t / 2)
    end

    def set_image_angle(delta_t)
      @image_angle = (delta_t / 5) % 360
    end

    def set_landing_coordinates
      Coordinates.new(
        coordinates.x + delta_x(landing_time),
        GameWindow::SCREEN_HEIGHT
      )
    end

    def set_landing_time
      @landing_time = (velocity.y - Math.sqrt(velocity.y * velocity.y - 2 * ACCELERATION * GameWindow::SCREEN_HEIGHT)) / ACCELERATION
    end
  end
end
