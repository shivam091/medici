# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Role < ApplicationRecord
  include Filterable

  attribute :is_active, default: false

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true
end
