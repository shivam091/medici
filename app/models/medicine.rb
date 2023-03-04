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

  validates :name,
            presence: true,
            length: {maximum: 255},
            reduce: true
  validates :proprietary_name,
            length: {maximum: 255},
            allow_blank: true,
            allow_nil: true,
            reduce: true
  validates :description,
            length: {maximum: 1000},
            allow_blank: true,
            allow_nil: true,
            reduce: true
  validates :batch_number,
            presence: true,
            length: {maximum: 55},
            reduce: true
  validates :code,
            length: {maximum: 15},
            reduce: true
  validates :therapeutic_areas,
            length: {maximum: 255},
            allow_blank: true,
            allow_nil: true,
            reduce: true
  validates :manufacture_date,
            presence: true,
            comparison: {
              less_than_or_equal_to: Date.current,
              less_than: :expiry_date
            },
            reduce: true
  validates :expiry_date,
            presence: true,
            comparison: {greater_than: Date.current},
            reduce: true
  validates :purchase_price,
            presence: true,
            reduce: true
  validates :sell_price,
            presence: true,
            numericality: {less_than_or_equal_to: :purchase_price},
            reduce: true
  validates :medicine_category_id,
            :dosage_form_id,
            :packing_type_id,
            :manufacturer_id,
            presence: true,
            reduce: true
  validates :uom, presence: true, reduce: true
  validates :strength,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true

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

  before_create :set_code
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
    last_code = self.class.maximum(:code)
    new_code = last_code.present? ? (last_code.scan(/\d+/).first.to_i + 1) : 1
    self.code = "MED" + new_code.to_s.rjust(10, "0")
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
