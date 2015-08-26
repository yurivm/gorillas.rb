module Gorillas
  Velocity = Struct.new("Velocity", :x, :y) do
    def magnitude
      @magnitude ||= Math.sqrt(x * x + y * y)
    end

    def to_s
      "#{format('%2.2f', x)} #{format('%2.2f', y)} #{format('%2.2f', magnitude)}"
    end
  end
end
