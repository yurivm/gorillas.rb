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
      @image.draw(coordinates.x + banana_x_at_time(t), coordinates.y + banana_y_at_time(t), ZOrder::Banana)
    end

    private

    attr_reader :coordinates, :velocity, :angle

    def degrees_to_radians(angle)
      Gosu.degrees_to_radians(angle)
    end

    def banana_x_at_time(time)
      # we have projections already, no need for sin/cos
      velocity.x * time
    end

    def banana_y_at_time(time)
      # we have projections already, no need for sin/cos
      velocity.y * time + (ACCELERATION * time * time / 2)
    end
  end
end
