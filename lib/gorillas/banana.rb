module Gorillas
  class Banana < Sprite
    IMAGE = Gosu::Image.new(Gorillas.configuration.banana_image_file)

    attr_reader :object_hit

    def initialize(coordinates)
      super(coordinates)
      @image = Gosu::Image.new(Gorillas.configuration.banana_image_file)
    end

    def launch(coordinates:, calculator:, time:)
      @starting_coordinates = coordinates.clone
      @coordinates = coordinates.clone
      @calculator = calculator
      @start_time = time
      @image_angle = 0
      @object_hit = nil
    end

    def update_position(time_elapsed)
      delta_t = (time_elapsed - start_time) / 1000.0
      return if delta_t < 0
      calculate_image_angle(time_elapsed)
      coordinates.x = starting_coordinates.x + calculator.delta_x(delta_t)
      coordinates.y = starting_coordinates.y + calculator.delta_y(delta_t)
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

    attr_reader :calculator, :image_angle, :start_time, :starting_coordinates

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

    def image
      IMAGE
    end

    def offscreen?
      coordinates.offscreen?
    end

    def lands_offscreen?
      calculator.lands_offscreen?
    end

    def calculate_image_angle(delta_t)
      @image_angle = (delta_t / 5) % 360
    end
  end
end
