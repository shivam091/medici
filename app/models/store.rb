# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Store < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false
  attribute :is_main_store, default: false

  has_many :users, dependent: :destroy

  default_scope -> { order_name_asc }

  class << self
    def main_store
      find_by(is_main_store: true)
    end

    def mini_stores
      where(is_main_store: false)
    end
  end
end
