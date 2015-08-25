module Gorillas
  class House
    attr_reader :x, :y, :width, :height, :color

    def initialize(x:, y:, width:, height:, color: Gosu::Color::RED)
      @x = x
      @y = y
      @width = width
      @height = height
      @color = color
    end

    def x2
      x + width
    end

    def draw
      Gosu.draw_quad(
        x, y, color,
        x2, y, color,
        x2, GameWindow::SCREEN_HEIGHT, color,
        x, GameWindow::SCREEN_HEIGHT, color,
        ZOrder::Houses
      )
    end
  end
end
