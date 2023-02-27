# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Ingredient < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  validates :name,
            presence: true,
            length: {maximum: 55},
            uniqueness: true,
            reduce: true
  validates :description,
            presence: true,
            length: {maximum: 1000},
            reduce: true

  has_many :medicine_ingredients, dependent: :restrict_with_exception
  has_many :medicines,
           through: :medicine_ingredients,
           source: :medicine,
           inverse_of: :medicine_ingredients

  default_scope -> { order_name_asc }

  class << self
    def select_options
      active.pluck(:name, :id)
    end
  end
end
