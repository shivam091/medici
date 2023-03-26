# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Expenses::CreateService < ApplicationService
  def initialize(user, expense_attributes)
    @user = user
    @expense_attributes = expense_attributes.dup
  end

  def call
    create_expense
  end

  private

  attr_reader :user, :expense_attributes

  def create_expense
    expense_attributes.merge!(user: user)
    expense = ::Expense.new(expense_attributes)
    if expense.save
      ::ServiceResponse.success(
        message: t("expenses.create.success"),
        payload: {expense: expense}
      )
    else
      ::ServiceResponse.error(
        message: t("expenses.create.error"),
        payload: {expense: expense}
      )
    end
  end
end
