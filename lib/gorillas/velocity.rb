module Gorillas
  Velocity = Struct.new("Velocity", :x, :y) do
    def to_s
      "#{sprintf('%2.2f', x)} #{sprintf('%2.2f', y)}"
    end
  end
end
