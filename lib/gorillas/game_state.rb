module Gorillas
  class GameState
    def initialize(gorillas)
      @gorillas = gorillas
      @calculator = ProjectileCalculator.new
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

      event :threw_banana do
        transition player1_aiming: :banana1_flying
        transition player2_aiming: :banana2_flying
      end

      event :banana_hit_a_house do
        transition banana1_flying: :player2_turn
        transition banana2_flying: :player1_turn
      end

      event :gorilla_scored do
        transition banana1_flying: :player1_celebrating
        transition banana2_flying: :player2_celebrating
      end

      event :banana_offscreen do
        transition banana1_flying: :player2_turn
        transition banana2_flying: :player1_turn
      end

      state :player1_celebrating do
        def ui_state_name
          "Player 1 scored!"
        end

        def angle_offset
          90
        end

      end

      state :player2_celebrating do
        def ui_state_name
          "Player 2 scored!"
        end

        def angle_offset
          180
        end
      end

      state :player1_aiming, :player1_turn, :banana1_flying do
        def active_gorilla_index
          0
        end

        def inactive_gorilla_index
          1
        end

        def active_gorilla
          gorillas[active_gorilla_index]
        end

        def inactive_gorilla
          gorillas[inactive_gorilla_index]
        end

        def angle_offset
          90
        end

        def ui_state_name
          "Turn: Player 1"
        end
      end

      state :player2_aiming, :player2_turn, :banana2_flying do
        def active_gorilla_index
          1
        end

        def inactive_gorilla_index
          0
        end

        def active_gorilla
          gorillas[active_gorilla_index]
        end

        def inactive_gorilla
          gorillas[inactive_gorilla_index]
        end

        def angle_offset
          180
        end

        def ui_state_name
          "Turn: Player 2"
        end
      end
    end


    def friendly_fire?(hit_gorilla)
      active_gorilla == hit_gorilla
    end

    def frag?(hit_gorilla)
      active_gorilla != hit_gorilla
    end

    def active_gorilla_coordinates
      active_gorilla.coordinates
    end

    def aiming?
      state == "player1_aiming" || state == "player2_aiming"
    end

    def banana_flying?
      state == "banana1_flying" || state == "banana2_flying"
    end

    def player_celebrating?
      state == "player1_celebrating" || state == "player2_celebrating"
    end

    def set_aim(x, y)
      calculator.set_values(active_gorilla_coordinates, Coordinates.new(x, y))
      calculator.calculate_params
    end

    def angle
      calculator.angle
    end

    def velocity
      calculator.velocity
    end

    def to_s
      "#{ui_state_name} Angle: #{formatted_angle} Velocity: #{formatted_velocity_magnitude}"
    end

    private

    def formatted_angle
      format('%2.2f', angle_in_degrees + angle_offset)
    end

    def formatted_velocity_magnitude
      format('%2.2f', velocity.magnitude)
    end

    def angle_in_degrees
      Gosu.radians_to_degrees(angle)
    end

    attr_reader :gorillas, :calculator
  end
end
