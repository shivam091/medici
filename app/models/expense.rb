# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Expense < ApplicationRecord
  include Sortable, ReferenceCode

  enum status: {
    pending: "pending",
    approved: "approved",
    rejected: "rejected"
  }

  attribute :amount, default: 0.0
  attribute :status, :enum, default: statuses[:pending]

  validates :criteria, presence: true, length: {maximum: 55}, reduce: true
  validates :amount,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true

  belongs_to :store, inverse_of: :expenses, optional: true
  belongs_to :user, inverse_of: :expenses

  before_create :set_store

  delegate :name, :phone_number, :email, to: :store, prefix: true

  default_scope -> { order_created_desc }

  private

  def set_store
    self.store = self.user.store
  end
end
