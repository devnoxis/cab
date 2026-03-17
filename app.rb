# frozen_string_literal: true

require 'rack'
require 'json'

class App
  def call(env)
    request = Rack::Request.new(env)

    if request.path == '/'
      [200, { 'content-type' => 'application/json' }, [{ message: 'Welcome' }.to_json]]
    elsif request.path == '/up'
      [200, { 'content-type' => 'application/json' }, [{ message: "I'm wokring" }.to_json]]
    else
      [404, { 'content-type' => 'application/json' }, [{ error: 'Not Found' }.to_json]]
    end
  end
end
