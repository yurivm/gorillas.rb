module Gorillas
  class GameState

    attr_reader :current_aim, :time

    def initialize(gorillas)
      set_gorilla_coordinates(gorillas)
      @current_aim = Coordinates.new(0, 0)
      @aiming_angle = 0
      @scaling_factor = Coordinates.new(0, 0)
      @velocity = 0
      @time = 0
      @calculator = BallisticsCalculator.new
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
        transition player1_aiming: :banana1_flying
        transition player2_aiming: :banana2_flying
      end

      event :banana_hit do
        transition banana1_flying: :player1_turn
        transition banana2_flying: :player2_turn
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

    def aiming?
      state == "player1_aiming" || state == "player2_aiming"
    end

    def banana_flying?
      state == "banana1_flying" || state == "banana2_flying"
    end

    def set_aim(x, y)
      calculator.set_initial_values(active_gorilla_coordinates, Coordinates.new(x, y))
      calculator.calculate_params
    end

    def angle; calculator.angle; end
    def velocity; calculator.velocity; end

    def active_gorilla_coordinates
      gorilla_coordinates[0]
    end

    def set_gorilla_coordinates(gorillas_collection)
      @gorilla_coordinates = []
      gorillas_collection.each_with_object(@gorilla_coordinates) do |gorilla, gorilla_coordinates|
        gorilla_coordinates << Coordinates.new(gorilla.x, gorilla.y)
      end
    end

    def reset_time!
      @time = 0
    end

    def add_time(time)
      @time += time
    end

    def to_s
      "state: #{state},angle #{sprintf('%2.2f', Gosu.radians_to_degrees(angle))}, velocity #{velocity}"
    end

    private

    attr_reader :gorilla_coordinates, :calculator

  end
end
