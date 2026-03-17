# frozen_string_literal: true

require 'rack/test'
require_relative '../app'

RSpec.describe App do
  include Rack::Test::Methods

  def app
    App.new
  end

  describe 'GET /' do
    it 'returns 200' do
      get '/'
      expect(last_response.status).to eq(200)
    end

    it 'returns welcome text' do
      get '/'
      expect(last_response.body).to eq('Welcome')
    end

    it 'returns plain text content type' do
      get '/'
      expect(last_response.content_type).to eq('text/plain')
    end
  end

  describe 'GET /other' do
    it 'returns 404' do
      get '/other'
      expect(last_response.status).to eq(404)
    end
  end
end
