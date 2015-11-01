module Gorillas
  class Sun < Sprite
    def initialize(coordinates)
      super
      init_animation
    end

    def hit!
      @hit = true
    end

    def x2
      @x2 ||= x + Gorillas.configuration.sun_tile_x_size
    end

    def y2
      @y2 ||= y + Gorillas.configuration.sun_tile_y_size
    end

    def bounding_box
      @bounding_box ||= BoundingBox.new(x, y, x2, y2)
    end

    private

    attr_reader :animation

    def image
      hit? ? animation.last : animation.first
    end

    def init_animation
      @animation = Gosu::Image.load_tiles(
        Gorillas.configuration.sun_image_file,
        Gorillas.configuration.sun_tile_x_size,
        Gorillas.configuration.sun_tile_y_size
      )
    end

    def hit?
      @hit
    end

    def z_order
      ZOrder::SUN
    end
  end
end
