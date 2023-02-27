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

  belongs_to :medicine, inverse_of: :medicine_ingredients, touch: true
  belongs_to :ingredient, inverse_of: :medicine_ingredients

  delegate :name, to: :ingredient, prefix: true
  delegate :name, to: :medicine, prefix: true
end
