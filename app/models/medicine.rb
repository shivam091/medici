# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Medicine < ApplicationRecord
  include Filterable, Sortable

  enum unit_of_measurement: {
    kg: "kg",
    g: "g",
    mg: "mg",
    mcg: "mcg",
    l: "l",
    ml: "ml",
    cc: "cc",
    mol: "mol",
    mmol: "mmol",
    ww: "ww",
    qs: "qs",
    wv: "wv",
    lb: "lb",
    f: "f",
    c: "c",
    oz: "oz",
    tbsp: "tbsp",
    tsp: "tsp",
    gtt: "gtt",
    gr: "gr",
    gal: "gal",
    pt: "pt",
    m: "m",
    qt: "qt",
    floz: "floz",
    fldr: "fldr",
    dr: "dr",
    vv: "vv"
  }

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

  after_initialize :set_code
  after_create :create_stock, :create_replenishment

  delegate :quantity_in_hand, to: :stock
  delegate :quantity_pending_from_supplier, to: :replenishment
  delegate :name, :email, :phone_number, to: :manufacturer, prefix: true
  delegate :name, to: :medicine_category, prefix: true
  delegate :name, to: :packing_type, prefix: true
  delegate :name, to: :dosage_form, prefix: true

  accepts_nested_attributes_for :medicine_ingredients,
                                allow_destroy: true,
                                reject_if: :reject_medicine_ingredient?

  default_scope -> { order(arel_table[:code].asc) }

  def stock
    super.presence || build_stock
  end

  def replenishment
    super.presence || build_replenishment
  end

  private

  def set_code
    self.code = "MED%.10d" % (self.class.count + 1)
  end

  def create_stock
    stock.save
  end

  def create_replenishment
    replenishment.save
  end

  def reject_medicine_ingredient?(attributes)
    attributes[:ingredient_id].blank? &&
      attributes[:strength].blank? &&
      attributes[:uom].blank?
  end
end
