# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineIngredient < ApplicationRecord
  attribute :active, default: false

  belongs_to :medicine, inverse_of: :medicine_ingredients
  belongs_to :ingredient, inverse_of: :medicine_ingredients

  delegate :name, to: :ingredient, prefix: true
  delegate :name, to: :medicine, prefix: true
end
