# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Expense < ApplicationRecord
  include Sortable

  attribute :amount, default: 0.0

  belongs_to :store, inverse_of: :expenses
  belongs_to :user, inverse_of: :expenses

  after_initialize :set_store

  default_scope -> { order_created_desc }

  private

  def set_store
    self.store = self.user.store
  end
end
