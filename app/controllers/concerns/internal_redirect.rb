# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module InternalRedirect
  extend ActiveSupport::Concern

  def safe_redirect_path(path)
    return unless path
    # Verify that the string starts with a `/` and a known route character.
    return unless path =~ %r{^/[-\w].*$}

    uri = URI(path)
    # Ignore anything path of the redirect except for the path, querystring and,
    # fragment, forcing the redirect within the same host.
    full_path_for_uri(uri)
  rescue URI::InvalidURIError
    nil
  end

  def safe_redirect_path_for_url(url)
    return unless url

    uri = URI(url)
    safe_redirect_path(full_path_for_uri(uri)) if host_allowed?(uri)
  rescue URI::InvalidURIError
    nil
  end

  def sanitize_redirect(url_or_path)
    safe_redirect_path(url_or_path) || safe_redirect_path_for_url(url_or_path)
  end

  def host_allowed?(uri)
    uri.host == request.host &&
      uri.port == request.port
  end

  def full_path_for_uri(uri)
    path_with_query = [uri.path, uri.query].compact.join('?')
    [path_with_query, uri.fragment].compact.join("#")
  end

  def referer_path(request)
    return unless request.referer.presence

    URI(request.referer).path
  end

  def secure_path_for(params, *excluded_params)
    url_for(request.parameters.except(*excluded_params).merge(only_path: true))
  end

  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end

  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    host = Rails.application.routes.default_url_options[:host]
    [subdomain, host].join
  end

  def redirect_back_or_default(default: root_path, options: {})
    redirect_back(fallback_location: default, **options)
  end
end
