# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class DeviseFailureApp < Devise::FailureApp

  def respond
    store_location!
    case warden_message
    when :suspended
      flash[:alert] = devise_failure_message_for(warden_message)
      redirect_to warden_options[:attempted_path]
    when :not_found_in_database
      login = params[warden_options[:scope]][:login] || params[warden_options[:scope]][:email]
      if params[warden_options[:scope]][:password].present?
        if login.match?(/^\+?\d*\z/)
          flash[:alert] = devise_failure_message_for(:not_found_with_mobile_number_and_password)
        else
          flash[:alert] = devise_failure_message_for(:not_found_with_email_address_and_password)
        end
      else
        if login.match?(/^\+?\d*\z/)
          flash[:alert] = devise_failure_message_for(:not_found_with_mobile_number)
        else
          flash[:alert] = devise_failure_message_for(:not_found_with_email_address)
        end
      end
      redirect_to warden_options[:attempted_path]
    else
      super
    end
  end

  def skip_format?
    %w(html turbo_stream */*).include? request_format.to_s
  end

  private

  def devise_failure_message_for(warden_message)
    I18n.t(warden_message, scope: "devise.failure")
  end
end
