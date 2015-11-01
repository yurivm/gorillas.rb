module Gorillas
  class Sun
    def initialize(x:, y:)
      @animation = Gosu::Image.load_tiles(
        Gorillas.configuration.sun_image_file,
        Gorillas.configuration.sun_tile_x_size,
        Gorillas.configuration.sun_tile_y_size
      )
      @coordinates = Coordinates.new(x, y)
      @hit = false
    end

    def x
      coordinates.x
    end

    def y
      coordinates.y
    end

    def draw
      current_tile.draw(x, y, ZOrder::SUN)
    end

    def hit?
      @hit
    end

    def hit!
      @hit = true
    end

    def bounding_box
      @bounding_box ||= BoundingBox.new(
        x,
        y,
        x + Gorillas.configuration.sun_tile_x_size,
        y + Gorillas.configuration.sun_tile_y_size
      )
    end


    private

    attr_reader :animation, :coordinates

    def current_tile
      hit? ? animation[1] : animation.first
    end
  end
end
