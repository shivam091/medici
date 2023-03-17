# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

require "sidekiq/scheduler"

Sidekiq.configure_server do |config|
  config.redis = REDIS_CLIENT
  config.average_scheduled_poll_interval = 20

  config.death_handlers << ->(job, ex) do
    puts "Uh oh, #{job["class"]} #{job["jid"]} just died with error #{ex.message}."
  end
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CLIENT
end

Sidekiq.default_job_options = {backtrace: true, retry: 3}
