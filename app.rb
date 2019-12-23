require 'sinatra'
require 'sinatra/base'
require 'rack'
require 'ostruct'

require_relative './config/redis'
require_relative './models/link'

# Shorty Sinatra App
class App < Sinatra::Base

  # Create a shortcode
  post '/shorten' do
    content_type :json

    params  = request.body.read
    link    = Link.new(params != '' ? JSON.parse(params) : {})
    unless link.valid?
      error = link.errors.first
      halt error.status, error(error.message).to_json
    end

    link.save
    status 201
    { shortcode: link.shortcode }.to_json
  end

  # Shortcode redirection
  get '/:shortcode' do
    content_type :json

    @link = set_link
    @link.increase_counter
    headers 'Location' => @link.url
    status 302
    {}.to_json
  end

  # Shortcode stats
  get '/:shortcode/stats' do
    content_type :json

    @link = set_link
    status 200
    @link.to_json
  end

  def set_link
    @link = Link.find(params[:shortcode])
    halt 404, error('Shortcode not found.').to_json if @link.nil?
    @link
  end

  def error(message)
    { errror: message }
  end
end