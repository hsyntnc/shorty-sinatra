require_relative '../spec_helper'

RSpec.describe 'Shorty ' do
  def app
    App
  end

  let(:valid_params) {{ url: 'https://impraise.com', shortcode: 'imprse' }}
  let(:valid_without_shortcode_params) {{ url: 'https://impraise.com' }}
  let(:invalid_params) {{url: 'https://impraise.com' , shortcode: 'an_invalid_shortcode'}}

  describe 'Shortcode generation' do
    it 'creates a shortcode with a valid url and shortcode given' do
      post '/shorten', valid_params.to_json
      parsed_body = JSON.parse(last_response.body)

      expect(last_response.status).to eq(201)
      expect(parsed_body['shortcode']).to eq valid_params[:shortcode]
      expect(parsed_body.keys).to eq(['shortcode'])
    end

    it 'creates a shortcode without a shortcode given' do
      post '/shorten', valid_without_shortcode_params.to_json
      parsed_body = JSON.parse(last_response.body)

      expect(last_response.status).to eq(201)
      expect(parsed_body.keys).to eq(%w(shortcode))
      expect(parsed_body['shortcode'].match("^[0-9a-zA-Z_]{6}$")).not_to eq nil
    end

    it 'returns error without a url' do
      post '/shorten'
      expect(last_response.status).to eq(400)
    end

    it 'returns an error if the shortcode given is not valid' do
      post '/shorten', invalid_params.to_json
      expect(last_response.status).to eq(422)
    end

    it 'returns an error if the shortcode is already in use' do
      link = Link.new(valid_params)
      link.save

      post '/shorten', valid_params.to_json
      expect(last_response.status).to eq(409)
    end
  end

  describe 'Shortcode endpoint' do
    it 'returns 302 if shortcode was found' do
      link = Link.new(valid_params)
      link.save

      get "/#{valid_params[:shortcode]}"
      expect(last_response.status).to eq(302)
      expect(last_response.headers['Location']).to eq(valid_params[:url])
    end

    it 'returns 404 if shortcode was not found' do
      get "/#{invalid_params[:shortcode]}"
      expect(last_response.status).to eq(404)
    end
  end

  describe 'Shortcode stats' do
    it 'returns shortcode stats with an existing code' do
      link = Link.new(valid_params)
      link.save

      get "/#{valid_params[:shortcode]}/stats"
      expect(last_response.status).to eq(200)

      parsed_body = JSON.parse(last_response.body)

      expect(parsed_body.keys).to eq(%w(startDate lastSeenDate redirectCount))
    end

    it 'returns 404 if shortcode was not found' do
      get "/#{invalid_params[:shortcode]}"
      expect(last_response.status).to eq(404)
    end
  end
end