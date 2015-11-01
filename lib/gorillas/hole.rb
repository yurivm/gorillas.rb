module Gorillas
  class Hole < Sprite
    IMAGE = Gosu::Image.new(Gorillas.configuration.hole_image_file)

    def draw
      IMAGE.draw_rot(x, y, ZOrder::HOLES, 0)
    end
  end
end
