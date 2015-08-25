require "gosu"

$:.unshift File.expand_path(File.dirname(__FILE__), "lib")
require "gorillas"

window = Gorillas::GameWindow.new
window.show

