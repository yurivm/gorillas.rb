module Gorillas
  class Explosion
    FRAME_DELAY = 12
    EXPLOSION_SOUND = Gosu::Sample.new("media/explosion.ogg")
    attr_reader :coordinates

    def initialize(coordinates)
      @animation = Gosu::Image.load_tiles("media/explosion.png", 64, 64)
      @coordinates = coordinates.clone
      @current_frame = 0
      EXPLOSION_SOUND.play
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
        ZOrder::Explosions,
        0.75,
        0.75
      )
    end

    def done?
      @done ||= @current_frame == animation.size
    end

    private

    attr_reader :animation

    def current_frame
      animation[@current_frame % @animation.size]
    end

    def frame_expired?
      now = Gosu.milliseconds
      @last_frame_timestamp ||= now
      if (now - @last_frame_timestamp) > FRAME_DELAY
        @last_frame_timestamp = now
      end
    end
  end
end
