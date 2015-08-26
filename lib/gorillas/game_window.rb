module Gorillas
  class GameWindow < Gosu::Window
    SCREEN_WIDTH = 800
    SCREEN_HEIGHT = 600
    HOUSES_COUNT = 8

    def initialize
      super SCREEN_WIDTH, SCREEN_HEIGHT
      self.caption = "Gorillas.rb"
      init_background
      init_filler
      init_score
      # init_background_music
      reset
    end

    def update
      case game_state.state
      when "player1_aiming", "player2_aiming"
        game_state.set_aim(mouse_x, mouse_y)
      when "banana1_flying", "banana2_flying"
        banana.update_position(Gosu.milliseconds)
        game_state.banana_offscreen! if banana.offscreen_and_will_not_return?
        if banana.hits_houses?(houses)
          explosions << Explosion.new(banana.explosion_coordinates)
          game_state.banana_hit_a_house!
        elsif banana.hits_gorillas?(gorillas)
          explosions << Explosion.new(banana.explosion_coordinates)
          if game_state.frag?(banana.object_hit)
            increment_score(game_state.active_gorilla_index)
          elsif game_state.friendly_fire?(banana.object_hit)
            decrement_score(game_state.active_gorilla_index)
          end
          game_state.banana_hit_a_gorilla!
          # you hit something! reset the game
          reset
        end
      end
      explosions.reject! do |explosion|
        if explosion.done?
          holes << Hole.new(explosion.coordinates)
          true
        end
      end
      explosions.map(&:update)
    end

    def button_down(id)
      if id == Gosu::MsLeft
        game_state.started_aiming! unless game_state.banana_flying?
      end
    end

    def button_up(id)
      if id == Gosu::MsLeft && game_state.aiming?
        banana.set_starting_conditions(
          coordinates: game_state.active_gorilla_coordinates,
          velocity: game_state.velocity,
          time: Gosu.milliseconds
        )
        game_state.stopped_aiming!
      end
    end

    def draw
      background_image.draw(0, 0, ZOrder::Background)
      houses.draw
      gorillas.draw
      draw_game_state
      draw_aiming_arrow if game_state.aiming?
      draw_banana if game_state.banana_flying?
      explosions.map(&:draw)
      holes.map(&:draw)
    end

    def needs_cursor?
      true
    end

    private

    attr_reader :background_image, :gorillas, :houses, :game_state, :aiming_arrow, :banana, :explosions, :holes

    def reset
      init_collections
      place_gorillas
      init_font
      init_aiming_arrow
      init_game_state
      init_banana
      init_explosions
      init_holes
    end

    def init_background
      @background_image = Gosu::Image.new("media/background.png", tileable: true)
    end

    def init_filler
      @filler = Gosu::Image.new("media/filler.png", tileable: true)
    end

    def init_score
      @score = [0, 0]
    end

    def init_background_music
      @background_music = Gosu::Song.new(self, "media/day_and_night.ogg")
      @background_music.volume = 0.5
      @background_music.play(true)
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

    def init_explosions
      @explosions = []
    end

    def init_holes
      @holes = []
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
        mouse_y
      )
    end

    def draw_banana
      banana.draw
    end

    def score
      "#{@score[0]}>Score<#{@score[1]}"
    end

    def increment_score(index)
      @score[index] += 1
    end

    def decrement_score(index)
      @score[index] -= 1
    end

    def draw_game_state
      txt = score
      txt_width = @font.text_width(txt)
      @filler.draw(SCREEN_WIDTH / 2 - txt_width / 2 - 18, SCREEN_HEIGHT - 60, ZOrder::UI)
      @font.draw(txt, SCREEN_WIDTH / 2 - txt_width / 2, SCREEN_HEIGHT - 60, ZOrder::UI, 1.0, 1.0, 0xff_ffffff)
      txt2 = "#{game_state}"
      @font.draw(txt2, 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
      txt3 = "Banana: #{banana}"
      @font.draw(txt3, 10, 30, 2, 1.0, 1.0, 0xff_ffff00)
    end
  end
end
