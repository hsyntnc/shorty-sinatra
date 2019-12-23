require 'sinatra'
require 'sinatra/base'
require 'rack'


class App < Sinatra::Base
  # Create a shortcode
  post '/shorten' do

  end

  # Shortcode redirection
  get '/:shortcode' do

  end

  # Shortcode stats
  get '/:shortcode/stats' do

  end
end