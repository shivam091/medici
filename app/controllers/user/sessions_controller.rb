# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class User::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params,
                :check_login_and_password_present,
                only: [:create]

  # GET /auth/sign-in
  def new
    without_timestamps do
      super
    end
  end

  # POST /auth/sign-in
  def create
    without_timestamps do
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in, user_name: resource.full_name)
      sign_in(resource_name, resource, event: :authentication)
      yield resource if block_given?

      if resource.reset_password_token.present?
        resource.update_columns(reset_password_token: nil, reset_password_sent_at: nil)
      end
    end
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /auth/sign-out
  def destroy
    without_timestamps do
      super
    end
  end

  private

  def check_login_and_password_present
    if params[:user][:login].blank? || params[:user][:password].blank?
      set_flash_message!(:error, :missing_email_mobile_or_password)
      redirect_to new_user_session_path and return
    end
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      stored_location_for(:user) || admin_dashboard_path
    elsif resource.cashier?
      stored_location_for(:user) || cashier_dashboard_path
    elsif resource.manager?
      stored_location_for(:user) || manager_dashboard_path
    else
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def configure_sign_in_params
    params.require(:user).permit(%i(login password remember_me)).merge!(login_required: true)
  end
end
