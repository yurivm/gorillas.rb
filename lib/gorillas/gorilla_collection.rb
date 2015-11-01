module Gorillas
  class GorillaCollection
    include Enumerable

    def initialize
      @gorillas = []
    end

    def create_gorilla(x:, y:, position:)
      @gorillas << Gorilla.new(Coordinates.new(x, y), position: position)
    end

    def stay_on_top_of_houses!(houses)
      @gorillas.map do |gorilla|
        house = houses.house_at(gorilla.x)
        gorilla.put_on_top_of_house(house)
      end
    end

    def draw
      @gorillas.map(&:draw)
    end

    def each(&block)
      @gorillas.each(&block)
    end

    def [](index)
      @gorillas[index]
    end
  end
end
