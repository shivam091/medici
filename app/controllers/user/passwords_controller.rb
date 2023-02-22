# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class User::PasswordsController < Devise::PasswordsController

  before_action :throttle_reset, only: :create

  # GET /auth/password/new
  def new
    super
  end

  # POST /auth/password
  def create
    without_timestamps do
      super
    end
  end

  # GET /auth/password/edit?reset_password_token=abcdef
  def edit
    super
    reset_password_token = Devise.token_generator.digest(
      ::User,
      :reset_password_token,
      resource.reset_password_token
    )
    unless reset_password_token.nil?
      user = ::User.where(
        ::User.arel_table[:reset_password_token].eq(reset_password_token)
      ).first_or_initialize

      if user.present?
        unless user.reset_password_period_valid?
          flash[:warning] = t(:token_expired, scope: translation_scope)
          redirect_to new_user_password_path(login: user.login)
        end
      else
        flash[:alert] = t(:token_invalid, scope: translation_scope)
        redirect_to new_user_password_path
      end
    end
  end

  # PUT|PATCH /auth/password
  def update
    super do |resource|
      if resource.valid?
        resource.touch(:last_password_updated_at)
      end
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  private

  def throttle_reset
    return if ::User::THROTTLE_RESET_PERIOD < 1
    self.resource = ::User.find_or_initialize_recoverable_with_errors(::User.reset_password_keys, user_params, :not_found)
    return unless resource && resource.recently_sent_password_reset_instructions?
    flash[:alert] = t(:throttle_reset, scope: translation_scope, count: ::User::THROTTLE_RESET_PERIOD)
    redirect_to new_user_session_path
  end

  def user_params
    params.require(:user).permit(:login, :reset_password_token, :password, :password_confirmation)
  end
end
