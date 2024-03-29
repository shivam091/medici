# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ProfilesController < ApplicationController
  # GET /(:role)/profile
  def show
  end

  # GET /(:role)/profile/edit
  def edit
  end

  # PUT/PATCH /(:role)/profile
  def update
    response = ::Profiles::UpdateService.(current_user, user_params)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.profile_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:user_form, partial: "profiles/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :mobile_number,
      address_attributes: [
        :address1,
        :address2,
        :city,
        :region,
        :country_id,
        :postal_code
      ]
    )
  end
end
