# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  layout proc { false if request.xhr? }

  include InternalRedirect,
          WithoutTimestamps

  def render_flash
    turbo_stream.update(:flash, partial: "shared/flash_messages")
  end
end
