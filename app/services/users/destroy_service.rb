# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Users::DestroyService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    destroy_user
  end

  private

  attr_reader :user

  def destroy_user
    if user.destroy
      ::ServiceResponse.success(
        message: t("users.destroy.success", user_name: user.full_name),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("users.destroy.success", user_name: user.full_name),
        payload: {user: user}
      )
    end
  end
end
