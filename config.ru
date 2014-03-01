$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require "sinatra"
require "dx_yokai_watch/app"

run DXYokaiWatch::Application
