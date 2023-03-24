# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class DosageForm < ApplicationRecord
  include Filterable, Sortable, Toggleable

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true

  has_many :medicines, dependent: :restrict_with_exception

  default_scope -> { order_name_asc }

  class << self
    def select_options
      active.pluck(:name, :id)
    end
  end
end
