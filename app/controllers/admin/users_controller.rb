# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::UsersController < Admin::BaseController

  before_action :find_user, except: [:index, :new, :create]

  # GET /admin/users
  def index
    @users = ::User.active.includes(:role, :store)
    @pagy, @users = pagy(@users)
  end

  # GET /admin/users/new
  def new
    @user = ::User.new
  end

  # POST /admin/users
  def create
    response = ::Users::CreateService.(user_params)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_users_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:user_form, partial: "admin/users/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/users/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/users/:uuid
  def update
    response = ::Users::UpdateService.(@user, user_params)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_users_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:user_form, partial: "admin/users/form"),
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
      :email,
      :mobile_number,
      :role_id,
      :store_id,
      :is_active,
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

  def find_user
    @user = ::User.find(params.fetch(:uuid))
  end
end
