# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Address < ApplicationRecord
  include Sortable

  validates :address1,
            presence: true,
            length: {maximum: 100},
            reduce: true
  validates :address2,
            length: {maximum: 100},
            allow_nil: true,
            allow_blank: true,
            reduce: true
  validates :city,
            presence: true,
            length: {maximum: 100},
            reduce: true
  validates :region,
            length: {maximum: 100},
            allow_nil: true,
            allow_blank: true,
            reduce: true
  validates :postal_code,
            length: {maximum: 20},
            allow_nil: true,
            allow_blank: true,
            reduce: true
  validates :country_id,
            presence: true,
            reduce: true

  belongs_to :addressable, polymorphic: true, optional: true
  belongs_to :country, inverse_of: :addresses

  delegate :name, to: :country, prefix: true

  default_scope -> { order_created_desc }

  def humanize
    [
      address1, address2, city, region, country_name, postal_code
    ].compact.reject(&:blank?).join(", ")
  end
end
