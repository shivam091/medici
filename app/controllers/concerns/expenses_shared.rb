# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ExpensesShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      before_action :find_expense, except: [:index, :new, :create]
      before_action do
        if action_name.in?(["index", "new", "create"])
          authorize ::Expense
        else
          authorize @expense
        end
      end

      # GET /(admin|manager|cashier)/expenses
      def index
        @expenses = policy_scope(::Expense)
        @pagy, @expenses = pagy(@expenses)
      end

      # GET /(admin|manager|cashier)/expenses/new
      def new
        @expense = ::Expense.new
      end

      # POST /(admin|manager|cashier)/expenses
      def create
        response = ::Expenses::CreateService.(current_user, expense_params)
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

  def expense_params
    params.require(:expense).permit(
      :criteria,
      :amount,
    )
  end
end
