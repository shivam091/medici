# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  layout proc { false if request.xhr? }

  include InternalRedirect,
          WithoutTimestamps,
          Pagy::Backend,
          Pundit::Authorization

  rescue_from Exception, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    if user_signed_in?
      sign_out(current_user)
    else
      redirect_to new_user_session_path
    end
  end
  rescue_from ActiveRecord::DeleteRestrictionError do |exception|
    redirect_to :back, alert: exception.message
  end
  rescue_from Pundit::NotAuthorizedError, with: :forbidden
  rescue_from ActionController::RoutingError, with: :not_found

  before_action :authenticate_user!

  def render_flash
    turbo_stream.update(:flash, partial: "shared/flash_messages")
  end

  def not_found
    render "errors/not_found", status: :not_found, layout: "error"
  end

  private

  def forbidden
    render "errors/forbidden", status: :forbidden, layout: "error"
  end

  def internal_server_error
    render "errors/internal_server_error", status: :internal_server_error, layout: "error"
  end
end
