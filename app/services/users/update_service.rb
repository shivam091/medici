# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Users::UpdateService < ApplicationService
  def initialize(user, user_attributes)
    @user = user
    @user_attributes = user_attributes.dup
  end

  def call
    update_user
  end

  private

  attr_reader :user, :user_attributes

  def update_user
    if user.update(user_attributes)
      ::ServiceResponse.success(
        message: t("users.update.success", user_name: user.full_name),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("users.update.error"),
        payload: {user: user}
      )
    end
  end
end
