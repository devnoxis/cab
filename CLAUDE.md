# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
bundle install

# Run all tests
bundle exec rspec

# Run a single test file
bundle exec rspec spec/app_spec.rb

# Run a single example by line number
bundle exec rspec spec/app_spec.rb:42

# Start the server
bundle exec rackup config.ru -p 3000
```

## Architecture

This is a **single-file Rack microservice** — not Rails. All application logic lives in `app.rb`, which defines one class (`App`) implementing the Rack interface via a `call(env)` method that routes requests by `PATH_INFO` and `REQUEST_METHOD`.

**Entry point:** `config.ru` requires `app.rb` and runs `App`.

**Routing:** Manual string matching inside `call` — no router gem. Pattern: check `path` and `method`, return `[status, headers, [body]]`.

**Endpoints:**
- `GET /` — welcome JSON
- `GET /up` — health check JSON
- `GET /info` — app metadata JSON
- `GET /about` — HTML landing page (rendered by `about_html` helper method)
- `GET /gen` — token generator; accepts `prefix` and `postfix` query params
- `POST /b64` — Base64-encodes a `body` form param
- anything else → 404 JSON

**Tests:** `spec/app_spec.rb` uses RSpec + `rack-test`. Include `Rack::Test::Methods` and set `app { App.new }` to mount the app in tests.

**No database, no Rails, no ActiveRecord.** The app is stateless.
