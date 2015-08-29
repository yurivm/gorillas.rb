module Gorillas
  Velocity = Struct.new("Velocity", :x, :y) do
    SCALE_X = 0.05
    SCALE_Y = 0.1

    def initialize(x, y)
      x *= SCALE_X
      y *= SCALE_Y
      super(x, y)
    end
    def to_s
      "#{sprintf('%2.2f', x)} #{sprintf('%2.2f', y)}"
    end
  end
end
