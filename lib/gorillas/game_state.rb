module Gorillas
  class GameState

    def initialize(gorillas)
      set_gorilla_coordinates(gorillas)
      super()
    end

    state_machine :state, initial: :player1_turn do
      event :player1_ended_turn do
        transition player1_turn: :player2_turn
      end

      event :player2_ended_turn do
        transition player2_turn: :player1_turn
      end

      event :started_aiming do
        transition player1_turn: :player1_aiming
        transition player2_turn: :player2_aiming
      end

      event :stopped_aiming do
        transition player1_aiming: :player1_turn
        transition player2_aiming: :player2_turn
      end

      state :player1_aiming, :player1_turn do
        def active_gorilla_coordinates
          gorilla_coordinates[0]
        end
      end

      state :player2_aiming, :player2_turn do
        def active_gorilla_coordinates
          gorilla_coordinates[1]
        end
      end
    end

    def aiming_x
      active_gorilla_coordinates.x
    end

    def aiming_y
      active_gorilla_coordinates.y
    end

    def active_gorilla_coordinates
      gorilla_coordinates[0]
    end

    def set_gorilla_coordinates(gorillas_collection)
      @gorilla_coordinates = []
      gorillas_collection.each_with_object(@gorilla_coordinates) do |gorilla, gorilla_coordinates|
        gorilla_coordinates << Coordinates.new(gorilla.x, gorilla.y)
      end
    end

    def to_s
      "state: #{state}, aiming_x #{aiming_x}, aiming_y #{aiming_y}"
    end

    private
    attr_reader :gorilla_coordinates

  end
end
