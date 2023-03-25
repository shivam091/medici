# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Users::DeactivateService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    deactivate_user
  end

  private

  attr_reader :user

  def deactivate_user
    if user.deactivate!
      ::ServiceResponse.success(
        message: t("users.deactivate.success", user_name: user.full_name),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("users.deactivate.error", user_name: user.full_name),
        payload: {user: user}
      )
    end
  end
end
