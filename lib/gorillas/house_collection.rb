module Gorillas
  class HouseCollection
    def initialize
      @houses = []
    end

    def draw
      @houses.map(&:draw)
    end

    def add_house(x:, y:, width:, height:, color:)
      house = House.new(x: x, y: y, width: width, height: height, color: color)
      @houses << house
      sort_by_x!
    end

    def house_at(x)
      @houses.find { |house| x >= house.x && x <= house.x2 }
    end

    def add_adjacent_house
      add_house(x: next_x_coordinate,
                y: HouseSizeGenerator.random_house_height,
                width: HouseSizeGenerator.random_house_width,
                height: HouseSizeGenerator.random_house_height,
                color: HouseSizeGenerator.random_color
      )
    end

    private

    def sort_by_x!
      @houses.sort! { |h1, h2| h1.x <=> h2.x }
    end

    def next_x_coordinate
      houses.empty? ? 0 : houses.last.x + houses.last.width
    end

    attr_reader :houses
  end
end
