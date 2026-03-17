# Autobot

A lightweight Ruby/Rack web API built for **Autobot** — a company creating advanced AI workflows that help with building digital products.

## About

This project is a minimal Rack-based HTTP API that serves as the foundation for Autobot's backend services. It returns JSON responses for all endpoints and is designed to be simple, fast, and easy to extend.

## Stack

- **Language:** Ruby
- **Framework:** Rack (no Rails — pure Rack for minimal footprint)
- **Testing:** RSpec + rack-test
- **Dependency management:** Bundler

## Requirements

- Ruby (see `.ruby-version` if present, or check `Gemfile.lock` — built on `arm64-darwin-25`)
- Bundler (`gem install bundler`)

## Setup

```bash
git clone <repo-url>
cd cabtest
bundle install
```

## Running the App

```bash
bundle exec rackup config.ru
```

The server starts on `http://localhost:9292` by default.

To specify a port:

```bash
bundle exec rackup config.ru -p 3000
```

## API Endpoints

| Method | Path    | Description                              | Response                                      |
|--------|---------|------------------------------------------|-----------------------------------------------|
| GET    | `/`     | Welcome message                          | `{ "message": "Welcome" }`                   |
| GET    | `/up`   | Health check                             | `{ "message": "I'm wokring" }`               |
| GET    | `/info` | App metadata (name, date, Ruby version)  | `{ "app": "Test", "date": "...", "ruby_version": "..." }` |
| *      | `*`     | Any other path                           | `{ "error": "Not Found" }` (404)             |

All responses use `Content-Type: application/json`.

## Running Tests

```bash
bundle exec rspec
```

Tests live in `spec/app_spec.rb` and cover all endpoints for status codes, content types, and response bodies.

## Deployment

This is a standard Rack app and can be deployed to any Rack-compatible host.

**Heroku / Render / Railway:**
```bash
# Procfile
web: bundle exec rackup config.ru -p $PORT -o 0.0.0.0
```

**Docker (example):**
```dockerfile
FROM ruby:3.x
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
CMD ["bundle", "exec", "rackup", "config.ru", "-p", "9292", "-o", "0.0.0.0"]
```

## Project Structure

```
.
├── app.rb          # Main Rack application
├── config.ru       # Rack entry point
├── Gemfile         # Dependencies
├── Gemfile.lock    # Locked dependency versions
└── spec/
    └── app_spec.rb # RSpec tests
```
