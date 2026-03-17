# frozen_string_literal: true

require 'rack'

class App
  def call(env)
    request = Rack::Request.new(env)

    if request.path == '/'
      [200, { 'content-type' => 'text/plain' }, ['Welcome']]
    else
      [404, { 'content-type' => 'text/plain' }, ['Not Found']]
    end
  end
end
