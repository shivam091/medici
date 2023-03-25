# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Users::ActivateService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    activate_user
  end

  private

  attr_reader :user

  def activate_user
    if user.activate!
      ::ServiceResponse.success(
        message: t("users.activate.success", user_name: user.full_name),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("users.activate.error", user_name: user.full_name),
        payload: {user: user}
      )
    end
  end
end
