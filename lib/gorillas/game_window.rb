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
      init_game_state
    end

    def update
    end

    def button_down(id)
      if id == Gosu::MsLeft
        game_state.started_aiming!
      end
    end

    def button_up(id)
      game_state.stopped_aiming! if id == Gosu::MsLeft
    end

    def draw
      background_image.draw(0, 0, ZOrder::Background)
      houses.draw
      gorillas.draw
      draw_game_state
    end

    def needs_cursor?
      true
    end

    private

    attr_reader :background_image, :gorillas, :houses, :game_state

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

    def init_game_state
      @game_state = Gorillas::GameState.new(gorillas)
    end

    def draw_game_state
      txt = "Mouse coordinates : X #{mouse_x} Y #{mouse_y} #{game_state}"
      @font.draw(txt, 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
    end
  end
end
