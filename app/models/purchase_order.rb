# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrder < ApplicationRecord
  include ReferenceCode

  has_many :purchase_order_medicines, dependent: :destroy
  has_many :medicines,
           through: :purchase_order_medicines,
           source: :medicine,
           inverse_of: :purchase_order_medicines

  belongs_to :store, inverse_of: :purchase_orders
  belongs_to :supplier, inverse_of: :purchase_orders
  belongs_to :user, inverse_of: :purchase_orders
end
