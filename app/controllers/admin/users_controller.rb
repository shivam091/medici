# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::UsersController < Admin::BaseController

  before_action :find_user, except: [:index, :active, :inactive, :banned, :new, :create]
  before_action do
    if action_name.in?(["index", "active", "inactive", "banned", "new", "create"])
      authorize ::User
    else
      authorize @user
    end
  end

  # GET /admin/users
  def index
    @users = policy_scope(::User).includes(:role, :store)
    @pagy, @users = pagy(@users)
  end

  # GET /admin/users/active
  def active
    @users = policy_scope(::User).active.includes(:role, :store)
    @pagy, @users = pagy(@users)
  end

  # GET /admin/users/inactive
  def inactive
    @users = policy_scope(::User).inactive.includes(:role, :store)
    @pagy, @users = pagy(@users)
  end

  # GET /admin/users/banned
  def banned
    @users = policy_scope(::User).banned.includes(:role, :store)
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

  # DELETE /admin/users/:uuid
  def destroy
    response = ::Users::DestroyService.(@user)
    @user = response.payload[:user]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_users_path
  end

  # PATCH /admin/users/:uuid/activate
  def activate
    response = ::Users::ActivateService.(@user)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to inactive_admin_users_path
  end

  # PATCH /admin/users/:uuid/deactivate
  def deactivate
    response = ::Users::DeactivateService.(@user)
    @user = response.payload[:user]
    if response.success?
      flash[:warning] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_users_path
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
    @user = policy_scope(::User).find(params.fetch(:uuid))
  end
end
