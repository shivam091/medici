# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ExpensesShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      # GET /(admin|manager|cashier)/expenses
      def index
        @expenses = policy_scope(::Expense)
        @pagy, @expenses = pagy(@expenses)
      end
    end
  end
end
