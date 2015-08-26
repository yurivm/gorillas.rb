module Gorillas
  class House
    X_WINDOW_MARGIN = 8
    Y_WINDOW_MARGIN = 10
    HOUSE_MARGIN = 2
    attr_reader :width, :height, :color

    def initialize(coordinates:, width:, height:, color: Gosu::Color::RED)
      @coordinates = coordinates.clone
      @width = width
      @height = height
      @color = color
      @dark_window = Gosu::Image.new("media/window_bright.png")
      @bright_window = Gosu::Image.new("media/window_dark.png")
      @windows = []
    end

    def x2
      @x2 ||= (x + width)
    end

    def x
      coordinates.x
    end

    def y2
      GameWindow::SCREEN_HEIGHT
    end

    def y
      coordinates.y
    end

    def draw
      Gosu.draw_quad(
        x, y, color,
        x2_minus_margin, y, color,
        x2_minus_margin, GameWindow::SCREEN_HEIGHT, color,
        x, GameWindow::SCREEN_HEIGHT, color,
        ZOrder::Houses
      )
      draw_windows
    end

    def bounding_box
      @bounding_box ||= BoundingBox.new(x, y, x2_minus_margin, y2)
    end

    private

    attr_reader :coordinates, :dark_window, :bright_window, :windows

    def x2_minus_margin
      x2 - HOUSE_MARGIN
    end

    def draw_windows
      counter = 0
      window_x = x + 3
      while window_x + X_WINDOW_MARGIN < x2 do
        window_y = y + Y_WINDOW_MARGIN / 2
        while window_y + Y_WINDOW_MARGIN < y2 do
          window_at(counter).draw(window_x, window_y, ZOrder::Windows)
          window_y += y_window_margin
          counter += 1
        end
        window_x += x_window_margin
      end
    end

    def x_window_margin
      dark_window.width + X_WINDOW_MARGIN
    end

    def y_window_margin
      dark_window.height + Y_WINDOW_MARGIN
    end

    def window_at(counter)
      return windows[counter] unless windows[counter].nil?
      windows << (rand > 0.5 ? dark_window : bright_window)
      windows.last
    end
  end
end
