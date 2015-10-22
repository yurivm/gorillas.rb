module Gorillas
  class Gorilla
    THROW_ANIMATION_TIME = 500
    CELEBRATION_ANIMATION_TIME = 3000
    CELEBRATION_FRAME_DELAY = 500

    attr_reader :coordinates
    attr_reader :x, :y

    def initialize(x:, y:, position:)
      @animation = Gosu::Image.load_tiles(
        Gorillas.configuration.gorilla_image_file,
        Gorillas.configuration.gorilla_tile_x_size,
        Gorillas.configuration.gorilla_tile_y_size
      )
      @coordinates = Coordinates.new(x, y)
      @throw_timestamp = nil
      @celebrate_timestamp = nil
      @hidden = false
      @position = position
    end

    def x
      coordinates.x
    end

    def y
      coordinates.y
    end

    def throw!
      @throw_timestamp = Gosu.milliseconds
    end

    def celebrate!
      @celebrate_timestamp = Gosu.milliseconds
    end

    def hide!
      @hidden = true
    end

    def draw
      image.draw(x, y, ZOrder::GORILLAS) unless hidden?
    end

    def bounding_box
      @bounding_box ||= create_bounding_box
    end

    def put_on_top_of_house(house)
      coordinates.x = house.x + (house.x2 - house.x) / 2
      coordinates.y = house.y - image.height
      create_bounding_box
    end

    def left?
      @position == :left
    end

    def right?
      @position == :right
    end

    def hidden?
      @hidden
    end

    private

    def image
      current_frame
    end

    def current_frame
      if throwing?
        banana_throwing_frame
      elsif celebrating?
        celebration_frame
      else
        @throw_timestamp = nil
        @celebrate_timestamp = nil
        base_frame
      end
    end

    def throwing?
      @throw_timestamp && Gosu.milliseconds - @throw_timestamp < THROW_ANIMATION_TIME
    end

    def celebrating?
      @celebrate_timestamp && Gosu.milliseconds - @celebrate_timestamp < CELEBRATION_ANIMATION_TIME
    end

    def base_frame
      @animation[0]
    end

    def banana_throwing_frame
      left? ? @animation[1] : @animation[2]
    end

    def celebration_frame
      now = Gosu.milliseconds
      ((now - @celebrate_timestamp) / CELEBRATION_FRAME_DELAY).even? ? @animation[1] : @animation[2]
    end

    def create_bounding_box
      BoundingBox.new(x, y, x + image.width, y + image.height)
    end
  end
end
