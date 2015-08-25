module Gorillas
  class GameWindow < Gosu::Window
    SCREEN_WIDTH = 800
    SCREEN_HEIGHT = 600
    HOUSES_COUNT = 8

    def initialize
      super SCREEN_WIDTH, SCREEN_HEIGHT
      self.caption = "Gorillas.rb"
      init_background
      init_collections
      place_gorillas
      init_font
    end

    def update
    end

    def draw
      background_image.draw(0, 0, 0)
      houses.draw
      gorillas.draw
      draw_mouse_coordinates
    end

    def needs_cursor?
      true
    end

    private

    attr_reader :background_image, :gorillas, :houses

    def init_background
      @background_image = Gosu::Image.new("media/background.png", tileable: true)
    end

    def init_collections
      @houses = HouseCollection.new
      HOUSES_COUNT.times { @houses.add_adjacent_house }
      @gorillas = GorillaCollection.new
    end

    def place_gorillas
      @gorillas.create_gorilla(x: rand(GameWindow::SCREEN_WIDTH / 4), y: 0)
      limit = 3 * (GameWindow::SCREEN_WIDTH / 4) + rand(GameWindow::SCREEN_WIDTH / 4)
      @gorillas.create_gorilla(x: limit, y: 0)
      @gorillas.stay_on_top_of_houses!(@houses)
    end

    def init_font
      @font = Gosu::Font.new(self, Gosu.default_font_name, 18)
    end

    def draw_mouse_coordinates
      txt = "Mouse coordinates : X #{mouse_x} Y #{mouse_y}"
      @font.draw(txt, 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
    end
  end
end
