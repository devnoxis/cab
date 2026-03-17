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

    it 'returns welcome JSON body' do
      get '/'
      expect(JSON.parse(last_response.body)).to eq('message' => 'Welcome')
    end

    it 'returns JSON content type' do
      get '/'
      expect(last_response.content_type).to eq('application/json')
    end
  end

  describe 'GET /other' do
    it 'returns 404' do
      get '/other'
      expect(last_response.status).to eq(404)
    end

    it 'returns JSON content type' do
      get '/other'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'returns JSON error body' do
      get '/other'
      expect(JSON.parse(last_response.body)).to eq('error' => 'Not Found')
    end
  end
end
