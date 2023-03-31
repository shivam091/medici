# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Expense < ApplicationRecord
  include Sortable, ReferenceCode, AASM

  enum status: {
    pending: "pending",
    approved: "approved",
    rejected: "rejected"
  }

  attribute :amount, default: 0.0
  attribute :status, :enum, default: statuses[:pending]

  aasm :expense_status, column: "status", enum: true do
    state :pending, initial: true
    state :approved, :rejected

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end
  end

  validates :user_id, presence: true, reduce: true
  validates :criteria, presence: true, length: {maximum: 55}, reduce: true
  validates :amount,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true
  validates :status,
            presence: true,
            inclusion: {in: statuses.values},
            reduce: true

  belongs_to :store, inverse_of: :expenses, optional: true
  belongs_to :user, inverse_of: :expenses

  before_save :set_store
  after_commit :broadcast_expenses_count, on: [:create, :destroy]

  delegate :name, :phone_number, :email, to: :store, prefix: true
  delegate :full_name, to: :user, prefix: true

  scope :including_user_and_store, -> { includes(user: [:role], store: [:currency]) }
  default_scope -> { order_created_desc }

  class << self
    def today
      where(
        ::Medici::SQL::Functions.date(::Expense[:created_at]).eq(Date.current)
      )
    end

    def this_month
      where(
        ::Medici::SQL::Functions.date(::Expense[:created_at]).in(Date.current.all_month)
      )
    end

    def accessible(user)
      if (user.super_admin? || user.admin?)
        all
      elsif user.manager?
        all.where(store: user.store)
      else
        user.expenses
      end
    end
  end

  private

  def set_store
    if user.present?
      self.store = self.user.store
    end
  end

  def broadcast_expenses_count
    broadcast_update_to(
      :expenses,
      target: :expenses_count,
      html: ::Expense.count
    )
  end
end
