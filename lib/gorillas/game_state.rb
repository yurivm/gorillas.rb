module Gorillas
  class GameState

    attr_reader :aiming_angle, :current_aim, :scaling_factor

    def initialize(gorillas)
      set_gorilla_coordinates(gorillas)
      @current_aim = Coordinates.new(0, 0)
      @aiming_angle = 0
      @scaling_factor = Coordinates.new(0, 0)
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

    def aiming?
      state == "player1_aiming" || state == "player2_aiming"
    end

    def aiming_x
      active_gorilla_coordinates.x
    end

    def aiming_y
      active_gorilla_coordinates.y
    end

    def set_aim(x, y)
      @current_aim.x = x
      @current_aim.y = y
      @aiming_angle = calculate_aiming_angle
      @scaling_factor = calculate_scaling_factor
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
      angle = Gosu.radians_to_degrees(aiming_angle)
      "state: #{state},aim x #{current_aim.x}, aim y #{current_aim.y}, angle #{sprintf('%2.2f', angle)}, scale x #{sprintf('%2.2f', scaling_factor.x)}, scale y #{sprintf('%2.2f', scaling_factor.y)}"
    end

    private

    attr_reader :gorilla_coordinates

    def calculate_aiming_angle
      return 0 unless aiming?
      x2 = current_aim.x - aiming_x
      y2 = current_aim.y - aiming_y
      Math.atan2(y2, x2)
    end

    def calculate_scaling_factor
      return unless aiming?
      scale_x = 1.5 * (current_aim.x - aiming_x).abs / aiming_x
      scale_y = 3 * (current_aim.y - aiming_y).abs / aiming_y
      scale_x = 1 if scale_x < 1
      scale_y = 1 if scale_y < 1
      Coordinates.new(scale_x, scale_y)
    end
  end
end
