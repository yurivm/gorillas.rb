module Gorillas
  class Gorilla < Sprite
    THROW_ANIMATION_TIME = 500
    CELEBRATION_ANIMATION_TIME = 3000
    CELEBRATION_FRAME_DELAY = 500

    def initialize(coordinates, position:)
      super(coordinates)
      @animation = Gosu::Image.load_tiles(
        Gorillas.configuration.gorilla_image_file,
        Gorillas.configuration.gorilla_tile_x_size,
        Gorillas.configuration.gorilla_tile_y_size
      )
      @throw_timestamp = nil
      @celebrate_timestamp = nil
      @hidden = false
      @position = position
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

    def x2
      x + image.width
    end

    def y2
      y + image.height
    end

    def bounding_box
      @bounding_box ||= BoundingBox.new(x, y, x2, y2)
    end

    def put_on_top_of_house(house)
      coordinates.x = house.x + (house.x2 - house.x) / 2
      coordinates.y = house.y - image.height
      @bounding_box = nil
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
  end
end
