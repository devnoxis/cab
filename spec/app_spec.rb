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

    context 'when Accept: text/html' do
      it 'returns 200' do
        get '/up', {}, 'HTTP_ACCEPT' => 'text/html'
        expect(last_response.status).to eq(200)
      end

      it 'returns HTML content type' do
        get '/up', {}, 'HTTP_ACCEPT' => 'text/html'
        expect(last_response.content_type).to eq('text/html')
      end

      it 'returns a green background page' do
        get '/up', {}, 'HTTP_ACCEPT' => 'text/html'
        expect(last_response.body).to include('#22c55e')
      end

      it 'includes service is up message' do
        get '/up', {}, 'HTTP_ACCEPT' => 'text/html'
        expect(last_response.body).to include('Service is up and running')
      end
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

    it 'returns user_agent from the request' do
      get '/info', {}, 'HTTP_USER_AGENT' => 'TestBrowser/1.0'
      body = JSON.parse(last_response.body)
      expect(body['user_agent']).to eq('TestBrowser/1.0')
    end

    it 'returns ip from the request' do
      get '/info', {}, 'REMOTE_ADDR' => '1.2.3.4'
      body = JSON.parse(last_response.body)
      expect(body['ip']).to eq('1.2.3.4')
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

    it 'includes language persistence script using localStorage' do
      get '/about'
      expect(last_response.body).to include('autobot-lang')
    end

    it 'saves lang to localStorage when lang param is present' do
      get '/about'
      expect(last_response.body).to include("localStorage.setItem(LANG_KEY, params.get('lang'))")
    end

    it 'redirects to stored lang when no lang param is in the URL' do
      get '/about'
      expect(last_response.body).to include("window.location.replace('?lang=' + stored)")
    end

    it 'validates lang value against allowed list before persisting' do
      get '/about'
      expect(last_response.body).to include("validLangs.indexOf(params.get('lang')) !== -1")
    end

    it 'includes system theme detection via prefers-color-scheme' do
      get '/about'
      expect(last_response.body).to include('prefers-color-scheme')
    end

    it 'includes language switcher with all four languages' do
      get '/about'
      expect(last_response.body).to include('?lang=en')
      expect(last_response.body).to include('?lang=pl')
      expect(last_response.body).to include('?lang=de')
      expect(last_response.body).to include('?lang=fr')
    end

    it 'renders lang buttons with visible border styling' do
      get '/about'
      expect(last_response.body).to include('border: 1px solid var(--border)')
      expect(last_response.body).to match(/\.lang-link\s*\{[^}]*border:/)
    end

    it 'renders lang buttons with hover background effect' do
      get '/about'
      expect(last_response.body).to include('rgba(120, 80, 255, 0.12)')
    end

    it 'renders lang buttons with CSS tooltip via data-tooltip attribute' do
      get '/about'
      expect(last_response.body).to include('data-tooltip="English"')
      expect(last_response.body).to include('data-tooltip="Polski"')
      expect(last_response.body).to include('data-tooltip="Deutsch"')
      expect(last_response.body).to include('data-tooltip="Français"')
    end

    it 'includes tooltip CSS using attr(data-tooltip)' do
      get '/about'
      expect(last_response.body).to include('content: attr(data-tooltip)')
    end

    it 'tooltip appears below language buttons using top positioning' do
      get '/about'
      expect(last_response.body).to include('top: calc(100% + 6px)')
      expect(last_response.body).not_to include('bottom: calc(100% + 6px)')
    end

    it 'defaults to English when no lang param given' do
      get '/about'
      expect(last_response.body).to include('lang="en"')
      expect(last_response.body).to include('Accelerated Development')
    end

    it 'marks the active language with lang-active class' do
      get '/about'
      expect(last_response.body).to match(/lang=en[^>]*lang-active|lang-active[^>]*lang=en/)
    end
  end

  describe 'GET /about?lang=pl' do
    it 'returns 200' do
      get '/about?lang=pl'
      expect(last_response.status).to eq(200)
    end

    it 'sets html lang attribute to pl' do
      get '/about?lang=pl'
      expect(last_response.body).to include('lang="pl"')
    end

    it 'renders Polish hero text' do
      get '/about?lang=pl'
      expect(last_response.body).to include('jest blisko')
    end

    it 'renders Polish feature card titles' do
      get '/about?lang=pl'
      expect(last_response.body).to include('Przyspieszone tworzenie')
      expect(last_response.body).to include('Inteligentny przegląd kodu')
    end

    it 'renders Polish nav labels' do
      get '/about?lang=pl'
      expect(last_response.body).to include('O nas')
      expect(last_response.body).to include('Funkcje')
    end

    it 'renders Polish contact title' do
      get '/about?lang=pl'
      expect(last_response.body).to include('Skontaktuj się')
    end

    it 'marks PL as active language' do
      get '/about?lang=pl'
      expect(last_response.body).to match(/lang=pl[^>]*lang-active|lang-active[^>]*lang=pl/)
    end
  end

  describe 'GET /about?lang=de' do
    it 'returns 200' do
      get '/about?lang=de'
      expect(last_response.status).to eq(200)
    end

    it 'sets html lang attribute to de' do
      get '/about?lang=de'
      expect(last_response.body).to include('lang="de"')
    end

    it 'renders German hero text' do
      get '/about?lang=de'
      expect(last_response.body).to include('ist nah')
    end

    it 'renders German feature card titles' do
      get '/about?lang=de'
      expect(last_response.body).to include('Beschleunigte Entwicklung')
      expect(last_response.body).to include('Intelligentes Code-Review')
    end

    it 'renders German nav labels' do
      get '/about?lang=de'
      expect(last_response.body).to include('Über uns')
      expect(last_response.body).to include('Funktionen')
    end

    it 'renders German contact title' do
      get '/about?lang=de'
      expect(last_response.body).to include('Kontakt aufnehmen')
    end

    it 'marks DE as active language' do
      get '/about?lang=de'
      expect(last_response.body).to match(/lang=de[^>]*lang-active|lang-active[^>]*lang=de/)
    end
  end

  describe 'GET /about?lang=fr' do
    it 'returns 200' do
      get '/about?lang=fr'
      expect(last_response.status).to eq(200)
    end

    it 'sets html lang attribute to fr' do
      get '/about?lang=fr'
      expect(last_response.body).to include('lang="fr"')
    end

    it 'renders French hero text' do
      get '/about?lang=fr'
      expect(last_response.body).to include('est proche')
    end

    it 'renders French feature card titles' do
      get '/about?lang=fr'
      expect(last_response.body).to include('Développement accéléré')
      expect(last_response.body).to include('Revue de code intelligente')
    end

    it 'renders French nav labels' do
      get '/about?lang=fr'
      expect(last_response.body).to include('À propos')
      expect(last_response.body).to include('Fonctionnalités')
    end

    it 'renders French contact title' do
      get '/about?lang=fr'
      expect(last_response.body).to include('Prendre contact')
    end

    it 'marks FR as active language' do
      get '/about?lang=fr'
      expect(last_response.body).to match(/lang=fr[^>]*lang-active|lang-active[^>]*lang=fr/)
    end
  end

  describe 'GET /about with unknown lang param' do
    it 'falls back to English' do
      get '/about?lang=xx'
      expect(last_response.body).to include('lang="en"')
      expect(last_response.body).to include('Accelerated Development')
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

  describe 'GET /api-docs' do
    it 'returns 200' do
      get '/api-docs'
      expect(last_response.status).to eq(200)
    end

    it 'returns HTML content type' do
      get '/api-docs'
      expect(last_response.content_type).to eq('text/html')
    end

    it 'includes page title' do
      get '/api-docs'
      expect(last_response.body).to include('API Documentation')
    end

    it 'lists all endpoint paths' do
      get '/api-docs'
      %w[/ /up /info /gen /b64 /about /api-docs].each do |path|
        expect(last_response.body).to include(path)
      end
    end

    it 'includes endpoint JSON data in the page' do
      get '/api-docs'
      expect(last_response.body).to include('var endpoints =')
    end

    it 'includes HTTP method labels' do
      get '/api-docs'
      expect(last_response.body).to include('"GET"')
      expect(last_response.body).to include('"POST"')
    end

    it 'includes parameter details for /gen' do
      get '/api-docs'
      expect(last_response.body).to include('prefix')
      expect(last_response.body).to include('postfix')
    end

    it 'includes parameter details for /b64' do
      get '/api-docs'
      expect(last_response.body).to include('"body"')
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