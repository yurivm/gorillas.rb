module Gorillas
  class HouseCollection
    class WidthAdjuster
      def initialize(next_x_coordinate, width)
        @next_x_coordinate = next_x_coordinate
        @width = width
      end

      def adjusted_house_width
        if width_fits_screen?
          remaining_space_too_narrow? ? GameWindow::SCREEN_WIDTH - @next_x_coordinate : @width
        else
          GameWindow::SCREEN_WIDTH - @next_x_coordinate
        end
      end

      private

      def width_fits_screen?
        next_boundary < GameWindow::SCREEN_WIDTH
      end

      def next_boundary
        @next_x_coordinate + @width
      end

      def remaining_space_too_narrow?
        GameWindow::SCREEN_WIDTH - next_boundary < HouseParametersGenerator::MIN_HOUSE_WIDTH
      end
    end

    include Enumerable

    attr_reader :houses

    def initialize
      @houses = []
    end

    def draw
      @houses.map(&:draw)
    end

    def <<(house)
      @houses << house
    end

    def house_at(x)
      @houses.find { |house| x >= house.x && x <= house.x2 }
    end

    def add_adjacent_house(width: HouseParametersGenerator.random_house_width)
      width = WidthAdjuster.new(next_x_coordinate, width).adjusted_house_width
      return if width == 0

      self << House.new(
        coordinates: Coordinates.new(next_x_coordinate, HouseParametersGenerator.random_house_height),
        width: width,
        height: HouseParametersGenerator.random_house_height,
        color: HouseParametersGenerator.random_color
      )
    end

    def each(&block)
      @houses.each(&block)
    end

    private

    def next_x_coordinate
      houses.empty? ? 0 : houses.last.x2
    end
  end
end
