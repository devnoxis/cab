# frozen_string_literal: true

require 'rack/test'
require 'base64'
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

    it 'includes light theme CSS variables' do
      get '/about'
      expect(last_response.body).to include('[data-theme="light"]')
    end

    it 'includes dark theme CSS variables in :root' do
      get '/about'
      expect(last_response.body).to match(/:root\s*\{[^}]*--bg:\s*#0a0a0f/)
    end

    it 'includes theme toggle button' do
      get '/about'
      expect(last_response.body).to include('id="theme-toggle"')
      expect(last_response.body).to include('aria-label="Toggle theme"')
    end

    it 'includes theme detection script using localStorage' do
      get '/about'
      expect(last_response.body).to include('autobot-theme')
      expect(last_response.body).to include('localStorage')
    end

    it 'includes system theme detection via prefers-color-scheme' do
      get '/about'
      expect(last_response.body).to include('prefers-color-scheme')
    end
  end

  describe 'GET /gen' do
    it 'returns 200' do
      get '/gen'
      expect(last_response.status).to eq(200)
    end

    it 'returns JSON content type' do
      get '/gen'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'returns a token' do
      get '/gen'
      body = JSON.parse(last_response.body)
      expect(body['token']).not_to be_nil
      expect(body['token']).not_to be_empty
    end

    it 'generates a different token each time' do
      get '/gen'
      token1 = JSON.parse(last_response.body)['token']
      get '/gen'
      token2 = JSON.parse(last_response.body)['token']
      expect(token1).not_to eq(token2)
    end

    it 'prepends prefix when given' do
      get '/gen?prefix=usr'
      token = JSON.parse(last_response.body)['token']
      expect(token).to start_with('usr_')
    end

    it 'appends postfix when given' do
      get '/gen?postfix=dev'
      token = JSON.parse(last_response.body)['token']
      expect(token).to end_with('_dev')
    end

    it 'supports prefix and postfix together' do
      get '/gen?prefix=usr&postfix=dev'
      token = JSON.parse(last_response.body)['token']
      expect(token).to start_with('usr_')
      expect(token).to end_with('_dev')
    end
  end

  describe 'POST /b64' do
    it 'returns 200' do
      post '/b64', body: 'hello'
      expect(last_response.status).to eq(200)
    end

    it 'returns JSON content type' do
      post '/b64', body: 'hello'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'returns base64 encoded body in result' do
      post '/b64', body: 'hello'
      expect(JSON.parse(last_response.body)).to eq('result' => Base64.strict_encode64('hello'))
    end

    it 'encodes arbitrary strings' do
      post '/b64', body: 'Test Autobot 123!'
      expect(JSON.parse(last_response.body)['result']).to eq(Base64.strict_encode64('Test Autobot 123!'))
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