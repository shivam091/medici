# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

Medici::Application.config.session_store :redis_store,
                                         key: "_medici_session",
                                         secure: Rails.env.production?,
                                         expire_after: 120.minutes, # cookie expiration
                                         ttl: 90.minutes, # Redis expiration, defaults to 'expire_after'
                                         redis: -> { REDIS_CLIENT },
                                         namespace: "session"
