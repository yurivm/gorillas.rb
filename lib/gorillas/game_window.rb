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
      init_background_music if Gorillas.configuration.background_sound_enabled?
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
        elsif banana.hits_sun?(sun)
          sun.hit!
        elsif banana.hits_gorillas?(gorillas)
          explosions << Explosion.new(banana.object_hit.coordinates, scaling_factor: 2.0)
          if game_state.frag?(banana.object_hit)
            increment_score(game_state.active_gorilla_index)
            game_state.active_gorilla.celebrate!
            game_state.inactive_gorilla.hide!
            init_celebration_timestamp
            game_state.gorilla_scored!
          elsif game_state.friendly_fire?(banana.object_hit)
            decrement_score(game_state.active_gorilla_index)
            game_state.inactive_gorilla.celebrate!
            game_state.active_gorilla.hide!
            init_celebration_timestamp
            game_state.gorilla_scored!
          end
        end
      when "player1_celebrating", "player2_celebrating"
        reset if celebration_time_elapsed?
      end
      update_explosions
    end

    def button_down(id)
      if id == Gosu::MsLeft
        game_state.started_aiming! unless game_state.banana_flying?
      elsif id == Gosu::KbF5
        reset
      end
    end

    def button_up(id)
      return unless id == Gosu::MsLeft && game_state.aiming?
      banana.launch(
        coordinates: game_state.adjusted_gorilla_coordinates,
        calculator: game_state.calculator,
        time: Gosu.milliseconds
      )
      game_state.active_gorilla.throw!
      game_state.threw_banana!
    end

    def draw
      background_image.draw(0, 0, ZOrder::BACKGROUND)
      houses.draw
      gorillas.draw
      sun.draw
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

    attr_reader :background_image, :gorillas, :houses, :sun, :game_state, :aiming_arrow, :banana, :explosions, :holes, :celebration_timestamp

    def reset
      init_collections
      place_gorillas
      init_font
      init_aiming_arrow
      init_game_state
      init_banana
      init_sun
      init_explosions
      init_holes
    end

    def init_background
      @background_image = Gosu::Image.new(Gorillas.configuration.background_image_file, tileable: true)
    end

    def init_filler
      @filler = Gosu::Image.new(Gorillas.configuration.filler_image_file, tileable: true)
    end

    def init_celebration_timestamp
      @celebration_timestamp = Gosu.milliseconds
    end

    def init_score
      @score = [0, 0]
    end

    def init_background_music
      @background_music = Gosu::Song.new(self, Gorillas.configuration.background_sound_file)
      @background_music.volume = Gorillas.configuration.background_sound_volume
      @background_music.play(true)
    end

    def init_collections
      @houses = HouseCollection.new
      HOUSES_COUNT.times { @houses.add_adjacent_house }
      @gorillas = GorillaCollection.new
    end

    def place_gorillas
      @gorillas.create_gorilla(x: rand(GameWindow::SCREEN_WIDTH / 4), y: 0, position: :left)
      limit = 3 * (GameWindow::SCREEN_WIDTH / 4) + rand(GameWindow::SCREEN_WIDTH / 4)
      @gorillas.create_gorilla(x: limit, y: 0, position: :right)
      @gorillas.stay_on_top_of_houses!(@houses)
    end

    def init_font
      @font = Gosu::Font.new(self, Gosu.default_font_name, 18)
    end

    def init_banana
      @banana = Banana.new(Coordinates.new(0, 0))
    end

    def init_sun
      sun_coordinates = Coordinates.new(
        (GameWindow::SCREEN_WIDTH - Gorillas.configuration.sun_tile_x_size) / 2,
        Gorillas.configuration.sun_tile_y_size / 2
      )
      @sun = Sun.new(sun_coordinates)
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
        game_state.active_gorilla_coordinates,
        game_state.angle,
        Coordinates.new(mouse_x, mouse_y)
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

    def celebration_time_elapsed?
      Gosu.milliseconds - celebration_timestamp > Gorilla::CELEBRATION_ANIMATION_TIME
    end

    def update_explosions
      explosions.reject! do |explosion|
        if explosion.done?
          holes << Hole.new(explosion.coordinates)
          true
        end
      end
      explosions.map(&:update)
    end

    def draw_game_state
      txt = score
      txt_width = @font.text_width(txt)
      @filler.draw(SCREEN_WIDTH / 2 - txt_width / 2 - 18, SCREEN_HEIGHT - 60, ZOrder::UI)
      @font.draw(txt, SCREEN_WIDTH / 2 - txt_width / 2, SCREEN_HEIGHT - 60, ZOrder::UI, 1.0, 1.0, 0xff_ffffff)
      txt2 = "#{game_state}"
      @font.draw(txt2, 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
    end
  end
end
