require 'sinatra'
require 'sinatra/base'
require 'rack'


class App < Sinatra::Base
  get '/' do
    "Hello World #{params[:name]}".strip
  end
end