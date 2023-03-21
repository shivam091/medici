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

  has_many :users, dependent: :restrict_with_exception

  class << self
    def select_options
      active.where.not(name: "super_admin").collect do |role|
        [role.name.humanize, role.id]
      end
    end
  end
end
