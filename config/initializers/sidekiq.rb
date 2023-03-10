# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

require "sidekiq/scheduler"

Sidekiq.configure_server do |config|
  config.redis = { url: Rails.application.credentials.config[:REDIS_URL] }
  config.average_scheduled_poll_interval = 20
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.application.credentials.config[:REDIS_URL] }
end

Sidekiq.default_job_options = { "backtrace" => true }
