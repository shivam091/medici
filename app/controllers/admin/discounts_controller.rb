# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::DiscountsController < Admin::BaseController

  before_action :find_discount, except: [:index, :new, :create]
  before_action do
    if action_name.in?(["index", "new", "create"])
      authorize ::Discount
    else
      authorize @discount
    end
  end

  # GET /admin/discounts
  def index
    @discounts = policy_scope(::Discount).includes(:country)
    @pagy, @discounts = pagy(@discounts)
  end

  # GET /admin/discounts/new
  def new
    @discount = ::Discount.new
  end

  # POST /admin/discounts
  def create
    response = ::Discounts::CreateService.(discount_params)
    @discount = response.payload[:discount]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_discounts_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:discount_form, partial: "admin/discounts/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/discounts/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/discounts/:uuid
  def update
    response = ::Discounts::UpdateService.(@discount, discount_params)
    @discount = response.payload[:discount]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_discounts_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:discount_form, partial: "admin/discounts/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/discounts/:uuid
  def destroy
    response = ::Discounts::DestroyService.(@discount)
    @discount = response.payload[:discount]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_discounts_path
  end

  private

  def find_discount
    @discount = policy_scope(::Discount).find(params.fetch(:uuid))
  end

  def discount_params
    params.require(:discount).permit(:country_id, :percent_off)
  end
end
