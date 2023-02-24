# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Store < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  has_many :users, dependent: :destroy

  default_scope -> { order_name_asc }
end
