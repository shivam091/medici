# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "rack"
require "ipinfo" unless defined?(IPinfo)

class IpInfo
  def initialize(app, cache_options = {})
    @app = app
    @token = Rails.application.credentials.config[:IP_LOOKUP_API_KEY]
    @cache_options = cache_options
    @ipinfo = ::IPinfo.create(@token, @cache_options)
  end

  def call(env)
    request = Rack::Request.new(env)
    ip = if Rails.env.development?
      "0.0.0.0"
    else
      request.ip
    end
    env["ipinfo"] = @ipinfo.details(ip).all
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end
