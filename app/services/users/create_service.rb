# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Users::CreateService < ApplicationService
  def initialize(user_attributes)
    @user_attributes = user_attributes.dup
  end

  def call
    create_user
  end

  private

  attr_reader :user_attributes

  def create_user
    # skip_confirmation = user_attributes.delete(:skip_confirmation)
    user = ::User.new(user_attributes)

    if user.save
      # user.tap do |email|
      #   user.confirm if skip_confirmation
      # end
      ::ServiceResponse.success(
        message: t("users.create.success", user_name: user.full_name),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("users.create.error"),
        payload: {user: user}
      )
    end
  end
end
