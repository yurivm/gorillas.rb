module Gorillas
  class Explosion
    FRAME_DELAY = 12
    EXPLOSION_SOUND = Gosu::Sample.new(Gorillas.configuration.explosion_sound_file)
    EXPLOSION_VOLUME = Gorillas.configuration.explosion_sound_volume
    attr_reader :coordinates

    def initialize(coordinates, scaling_factor: 0.75)
      @animation = Gosu::Image.load_tiles(
        Gorillas.configuration.explosion_image_file,
        Gorillas.configuration.explosion_tile_x_size,
        Gorillas.configuration.explosion_tile_y_size
      )
      @coordinates = coordinates.clone
      @current_frame = 0
      @scaling_factor = scaling_factor
      EXPLOSION_SOUND.play(EXPLOSION_VOLUME) if Gorillas.configuration.explosion_sound_enabled?
    end

    def update
      @current_frame += 1 if frame_expired?
    end

    def x
      coordinates.x
    end

    def y
      coordinates.y
    end

    def draw
      return if done?
      image = current_frame
      image.draw(
        x - image.width / 2.0,
        y - image.height / 2.0,
        ZOrder::EXPLOSIONS,
        scaling_factor,
        scaling_factor
      )
    end

    def done?
      @done ||= @current_frame == animation.size
    end

    private

    attr_reader :animation, :scaling_factor

    def current_frame
      animation[@current_frame % @animation.size]
    end

    def frame_expired?
      now = Gosu.milliseconds
      @last_frame_timestamp ||= now
      return unless (now - @last_frame_timestamp) > FRAME_DELAY
      @last_frame_timestamp = now
    end
  end
end
