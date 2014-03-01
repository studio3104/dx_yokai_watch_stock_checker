require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'kaminari/sinatra'
require 'dx_yokai_watch/aggregator'

module DXYokaiWatch
  class Application < Sinatra::Base
    configure do
      Slim::Engine.default_options[:pretty] = true
      app_root = File.dirname(__FILE__) + '/../..'
      set :public_folder, app_root + '/public'
      set :views, app_root + '/views'
    end

    configure :development do
      register Sinatra::Reloader
      set :show_exceptions, false
      set :show_exceptions, :after_handler
    end

    get '/' do
      @stock_informations = DXYokaiWatch::Aggregator.get_stock_informations
      slim :index
    end
  end
end
