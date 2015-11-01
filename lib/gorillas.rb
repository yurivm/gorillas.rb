Bundler.require
require "yaml"
require "recursive-open-struct"

# the config goes first as some classes call its methods
module Gorillas
  CONFIG = RecursiveOpenStruct.new(YAML.load_file("config/gorillas.yml"))

  class << self
    attr_accessor :configuration
  end

  class Configuration
    def arrow_image_file
      CONFIG.images.arrow.file
    end

    def background_image_file
      CONFIG.images.ui.background.file
    end

    def banana_image_file
      CONFIG.images.banana.file
    end

    def explosion_image_file
      CONFIG.images.explosion.file
    end

    def explosion_tile_x_size
      CONFIG.images.explosion.tile_x_size
    end

    def explosion_tile_y_size
      CONFIG.images.explosion.tile_y_size
    end

    def hole_image_file
      CONFIG.images.hole.file
    end

    def house_dark_window_image_file
      CONFIG.images.house.window_dark.file
    end

    def house_bright_window_image_file
      CONFIG.images.house.window_bright.file
    end

    def filler_image_file
      CONFIG.images.ui.filler.file
    end

    def gorilla_image_file
      CONFIG.images.gorilla.file
    end

    def gorilla_tile_x_size
      CONFIG.images.gorilla.tile_x_size
    end

    def gorilla_tile_y_size
      CONFIG.images.gorilla.tile_y_size
    end

    def explosion_sound_file
      CONFIG.sounds.explosion.file
    end

    def explosion_sound_volume
      CONFIG.sounds.explosion.volume
    end

    def explosion_sound_enabled?
      CONFIG.sounds.explosion.enabled
    end

    def sun_image_file
      CONFIG.images.sun.file
    end

    def sun_tile_x_size
      CONFIG.images.sun.tile_x_size
    end

    def sun_tile_y_size
      CONFIG.images.sun.tile_y_size
    end

    def background_sound_file
      CONFIG.sounds.background.file
    end

    def background_sound_volume
      CONFIG.sounds.background.volume
    end

    def background_sound_enabled?
      CONFIG.sounds.background.enabled
    end

    def acceleration
      CONFIG.options.acceleration
    end
  end

  self.configuration = Configuration.new
end

require "gorillas/coordinates"
require "gorillas/bounding_box"
require "gorillas/velocity"
require "gorillas/sprite"
require "gorillas/banana"
require "gorillas/explosion"
require "gorillas/hole"
require "gorillas/windows"
require "gorillas/house"
require "gorillas/house_collection"
require "gorillas/house_parameters_generator"
require "gorillas/gorilla"
require "gorillas/gorilla_collection"
require "gorillas/aiming_arrow"
require "gorillas/game_window"
require "gorillas/sun"
require "gorillas/z_order"
require "gorillas/projectile_calculator"
require "gorillas/game_state"
