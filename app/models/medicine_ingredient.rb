# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineIngredient < ApplicationRecord

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

  attribute :active, default: false

  validates :medicine_id, presence: true, reduce: true, on: :update
  validates :ingredient_id, presence: true, reduce: true
  validates :strength,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true
  validates :uom,
            presence: true,
            inclusion: {in: unit_of_measurements.keys},
            reduce: true

  belongs_to :medicine, inverse_of: :medicine_ingredients, touch: true
  belongs_to :ingredient, inverse_of: :medicine_ingredients
end
