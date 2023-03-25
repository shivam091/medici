# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "7.0.4.2"

# Add bootstrap support
gem "bootstrap", "~> 5.2.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Flexible authentication solution for Rails with Warden
gem "devise", "4.9.0"

# Authorization
gem "pundit"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# HTML Abstraction Markup Language. Use Haml as Templating Language
gem "haml"

# Job and worker scheduler
gem "sidekiq", "~> 6"
gem "sidekiq-scheduler", "~> 5"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.7.1"

# Use Redis for session storage
gem "redis-actionpack"

# Ultimate pagination.
gem "pagy", "~> 5.1"

# IP address lookup
gem "IPinfo", "~> 1.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Image processing library
gem "ruby-vips"

# Twilio APIs
gem "twilio-ruby", "~> 5"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # Help to kill N+1 queries and unused eager loading
  gem "bullet"

  # Alternative testing tool for Ruby on Rails
  gem "rspec-rails", "~> 5.0.0"

  # Provides one-liners to test common Rails functionality
  gem "shoulda-matchers", "~> 5.0"

  # Clean your ActiveRecord databases with database cleaner.
  gem "database_cleaner"

  # Fixtures replacement with a straightforward definition syntax.
  gem "factory_bot_rails"

  # Use the Puma web server [https://github.com/puma/puma]
  gem "puma", "~> 5.6"

  # Pretty print your Ruby objects with style -- in full color and with proper indentation
  gem "awesome_print", "~> 1.8"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "simplecov", require: false
  # Support simple parameterized test syntax in RSpec.
  gem "rspec-parameterized"
end

group :production do
  # Use Passenger as the app server for production env.
  gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"
end
