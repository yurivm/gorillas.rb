module Gorillas
  class Banana
    ACCELERATION = 9.81

    def initialize(x: 0, y: 0)
      @coordinates = Coordinates.new(x, y)
      @time = 0
      @angle = 0
      @image = Gosu::Image.new("media/hammer_and_sickle.png")
    end

    def update(x:, y:, angle:, velocity:)
      @coordinates.x = x
      @coordinates.y = y
      @angle = degrees_to_radians(angle)
      @velocity = velocity
    end

    def draw(time)
      #puts "X #{banana_x_at_time(time)}, Y #{banana_y_at_time(time)}, time #{time}"
      t = time / 1000
      coordinates.x = coordinates.x + banana_x_at_time(t)
      coordinates.y = coordinates.y + banana_y_at_time(t)
      @image.draw(coordinates.x, coordinates.y, ZOrder::Banana)
    end

    private

    attr_reader :coordinates, :velocity, :angle

    def degrees_to_radians(angle)
      Gosu.degrees_to_radians(angle)
    end

    def banana_x_at_time(time)
      velocity.x * time * Math.cos(angle)
    end

    def banana_y_at_time(time)
      velocity.y * time * Math.sin(angle) - (ACCELERATION * time * time / 2)
    end
  end
end
