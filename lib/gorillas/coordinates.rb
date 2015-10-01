module Gorillas
  Coordinates = Struct.new("Coordinates", :x, :y) do
    def x_offscreen?
      x < 0 || x > GameWindow::SCREEN_WIDTH
    end

    def y_offscreen?
      y < 0 || y > GameWindow::SCREEN_HEIGHT
    end

    def offscreen?
      x_offscreen? || y_offscreen?
    end
  end
end
