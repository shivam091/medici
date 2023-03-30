# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ExpensesShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      before_action :find_expense, only: [:edit, :update, :destroy]
      before_action do
        if action_name.in?(["edit", "update", "destroy"])
          authorize @expense
        else
          authorize ::Expense
        end
      end

      # GET /(admin|manager|cashier)/expenses
      def index
        @expenses = policy_scope(::Expense).with_associations
        @pagy, @expenses = pagy(@expenses)
      end

      # GET /(admin|manager|cashier)/expenses/pending
      def pending
        @expenses = policy_scope(::Expense).pending.with_associations
        @pagy, @expenses = pagy(@expenses)
      end

      # GET /(admin|manager|cashier)/expenses/approved
      def approved
        @expenses = policy_scope(::Expense).approved.with_associations
        @pagy, @expenses = pagy(@expenses)
      end

      # GET /(admin|manager|cashier)/expenses/rejected
      def rejected
        @expenses = policy_scope(::Expense).rejected.with_associations
        @pagy, @expenses = pagy(@expenses)
      end

      # GET /(admin|manager|cashier)/expenses/new
      def new
        @expense = ::Expense.new
      end

      # POST /(admin|manager|cashier)/expenses
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

      # GET /(admin|manager|cashier)/expenses/:uuid/edit
      def edit
      end

      # PUT/PATCH /(admin|manager|cashier)/expenses/:uuid
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

      # DELETE /(admin|manager|cashier)/expenses/:uuid
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
    end
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
