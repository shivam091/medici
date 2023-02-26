# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Medicine < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  has_one :stock, dependent: :destroy
  has_one :replenishment, dependent: :destroy

  has_many :medicine_suppliers, dependent: :destroy
  has_many :suppliers,
           through: :medicine_suppliers,
           source: :supplier,
           inverse_of: :medicine_suppliers
  has_many :medicine_ingredients, dependent: :destroy
  has_many :ingredients,
           through: :medicine_ingredients,
           source: :ingredient,
           inverse_of: :medicine_ingredients

  belongs_to :manufacturer, inverse_of: :medicines
  belongs_to :medicine_category, inverse_of: :medicines
  belongs_to :packing_type, inverse_of: :medicines
  belongs_to :dosage_form, inverse_of: :medicines

  after_create :create_stock, :create_replenishment

  delegate :quantity_in_hand, to: :stock
  delegate :quantity_pending_from_supplier, to: :replenishment
  delegate :name, :email, :phone_number, to: :manufacturer, prefix: true
  delegate :name, to: :medicine_category, prefix: true
  delegate :name, to: :packing_type, prefix: true
  delegate :name, to: :dosage_form, prefix: true

  default_scope -> { order(arel_table[:code].asc) }

  def stock
    super.presence || build_stock
  end

  def replenishment
    super.presence || build_replenishment
  end

  private

  def create_stock
    stock.save
  end

  def create_replenishment
    replenishment.save
  end
end
