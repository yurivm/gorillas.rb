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
      init_aiming_arrow
      init_game_state
      init_banana
    end

    def update
      case game_state.state
        when "player1_aiming", "player2_aiming"
          game_state.set_aim(mouse_x, mouse_y)
        when "banana1_flying", "banana2_flying"
          game_state.add_time(update_interval)
      end
    end

    def button_down(id)
      if id == Gosu::MsLeft
        # TODO debug only, remove later
        game_state.banana_hit! if game_state.banana_flying?
        game_state.started_aiming!
      end
    end

    def button_up(id)
      if id == Gosu::MsLeft
        banana.update(
          x: game_state.active_gorilla_coordinates.x,
          y: game_state.active_gorilla_coordinates.y,
          angle: game_state.angle,
          velocity: game_state.velocity
        )
        game_state.stopped_aiming!
        game_state.reset_time!
      end
    end

    def draw
      background_image.draw(0, 0, ZOrder::Background)
      houses.draw
      gorillas.draw
      draw_game_state
      if game_state.aiming?
        draw_aiming_arrow
      end
      if game_state.banana_flying?
        draw_banana
      end
    end

    def needs_cursor?
      true
    end

    private

    attr_reader :background_image, :gorillas, :houses, :game_state, :aiming_arrow, :banana

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

    def init_banana
      @banana = Banana.new
    end

    def init_game_state
      @game_state = Gorillas::GameState.new(gorillas)
    end

    def init_aiming_arrow
      @aiming_arrow = Gorillas::AimingArrow.new
    end

    def draw_aiming_arrow
      aiming_arrow.draw_scaled_and_rotated(
        game_state.active_gorilla_coordinates.x,
        game_state.active_gorilla_coordinates.y,
        game_state.angle,
        mouse_x,
        mouse_y,
      )
    end

    def draw_banana
      banana.draw(game_state.time)
    end

    def draw_game_state
      txt = "Mouse coordinates : X #{mouse_x} Y #{mouse_y}"
      @font.draw(txt, 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
      txt2 = "#{game_state}"
      @font.draw(txt2, 10, 50, 2, 1.0, 1.0, 0xff_ffff00)
    end
  end
end
