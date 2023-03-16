# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

# https://t2013anurag.medium.com/rails-shared-redis-connection-pool-between-sidekiq-and-application-a448f78fdb35

pool_size = ENV.fetch("RAILS_MAX_THREADS") { 20 }

REDIS_CLIENT = ConnectionPool.new(size: pool_size) do
  Redis.new(
    url: Rails.application.credentials.config[:REDIS_URL],
    ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}
  )
end
