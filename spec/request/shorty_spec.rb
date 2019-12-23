require_relative '../spec_helper'

RSpec.describe 'Shorty ' do
  def app
    App
  end

  describe 'Shortcode generation' do
    it 'creates a shortcode with a valid url and shortcode given'
    it 'creates a shortcode without a shortcode given'
    it 'returns error without a url'
    it 'returns an error if the shortcode given is not valid'
    it 'returns an error if the shortcode is already in use'
  end

  describe 'Shortcode endpoint' do
    it 'returns 302 if shortcode was found'
    it 'returns 404 if shortcode was not found'
  end

  describe 'Shortcode stats' do
    it 'returns shortcode stats with an existing code'
    it 'returns 404 if shortcode was not found'
  end
end