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

  describe 'GET /up' do
    it 'returns 200' do
      get '/up'
      expect(last_response.status).to eq(200)
    end

    it 'returns JSON content type' do
      get '/up'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'returns working JSON body' do
      get '/up'
      expect(JSON.parse(last_response.body)).to eq('message' => "I'm wokring")
    end
  end

  describe 'GET /info' do
    it 'returns 200' do
      get '/info'
      expect(last_response.status).to eq(200)
    end

    it 'returns JSON content type' do
      get '/info'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'returns app name, current date, and ruby version' do
      get '/info'
      body = JSON.parse(last_response.body)
      expect(body['app']).to eq('Test')
      expect(body['date']).to eq(Time.now.strftime('%Y-%m-%d'))
      expect(body['ruby_version']).to eq(RUBY_VERSION)
    end
  end

  describe 'GET /about' do
    it 'returns 200' do
      get '/about'
      expect(last_response.status).to eq(200)
    end

    it 'returns HTML content type' do
      get '/about'
      expect(last_response.content_type).to eq('text/html')
    end

    it 'returns HTML body with hero title' do
      get '/about'
      expect(last_response.body).to include('AutoBot AI workflow')
      expect(last_response.body).to include('is near')
    end

    it 'returns HTML body with company contact info' do
      get '/about'
      expect(last_response.body).to include('123 Innovation Street')
      expect(last_response.body).to include('hello@autobot.dev')
      expect(last_response.body).to include('support@autobot.dev')
      expect(last_response.body).to include('+1 (415) 555-0123')
    end

    it 'returns HTML body with feature cards' do
      get '/about'
      expect(last_response.body).to include('Accelerated Development')
      expect(last_response.body).to include('Intelligent Code Review')
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
