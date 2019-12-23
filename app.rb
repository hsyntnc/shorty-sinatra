require 'sinatra'
require 'sinatra/base'
require 'rack'

require_relative 'config/redis'

class App < Sinatra::Base
  # Create a shortcode
  post '/shorten' do
    content_type :json

  end

  # Shortcode redirection
  get '/:shortcode' do
    content_type :json

  end

  # Shortcode stats
  get '/:shortcode/stats' do
    content_type :json

  end
end