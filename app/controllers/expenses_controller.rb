# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ExpensesController < ApplicationController
  before_action :find_expense, only: [:edit, :update, :destroy, :approve, :reject]
  before_action do
    if action_name.in?(["edit", "update", "destroy", "approve", "reject"])
      authorize @expense
    else
      authorize ::Expense
    end
  end

  # GET /(:role)/expenses
  def index
    @expenses = policy_scope(::Expense)
    @pagy, @expenses = pagy(@expenses)
  end

  # GET /(:role)/expenses/pending
  def pending
    @expenses = policy_scope(::Expense).pending
    @pagy, @expenses = pagy(@expenses)
  end

  # GET /(:role)/expenses/approved
  def approved
    @expenses = policy_scope(::Expense).approved
    @pagy, @expenses = pagy(@expenses)
  end

  # GET /(:role)/expenses/rejected
  def rejected
    @expenses = policy_scope(::Expense).rejected
    @pagy, @expenses = pagy(@expenses)
  end

  # GET /(:role)/expenses/new
  def new
    @expense = ::Expense.new
  end

  # POST /(:role)/expenses
  def create
    response = ::Expenses::CreateService.(user, expense_params)
    @expense = response.payload[:expense]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.expenses_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:expense_form, partial: "expenses/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /(:role)/expenses/:uuid/edit
  def edit
  end

  # PUT/PATCH /(:role)/expenses/:uuid
  def update
    response = ::Expenses::UpdateService.(@expense, expense_params)
    @expense = response.payload[:expense]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.expenses_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:expense_form, partial: "expenses/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /(:role)/expenses/:uuid
  def destroy
    response = ::Expenses::DestroyService.(@expense)
    @expense = response.payload[:expense]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to helpers.expenses_path
  end

  # PATCH /(:role)/expenses/:uuid/approve
  def approve
    response = ::Expenses::ApproveService.(@expense)
    @expense = response.payload[:expense]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to helpers.pending_expenses_path
  end

  # PATCH /(:role)/expenses/:uuid/reject
  def reject
    response = ::Expenses::RejectService.(@expense)
    @expense = response.payload[:expense]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to helpers.pending_expenses_path
  end

  private

  def find_expense
    @expense = policy_scope(::Expense).find(params.fetch(:uuid))
  end

  def user
    if (current_user.manager? || current_user.cashier?)
      current_user
    else
      ::User.find_by(id: expense_params.fetch(:user_id))
    end
  end

  def expense_params
    params.require(:expense).permit(
      :user_id,
      :criteria,
      :amount,
    )
  end
end
