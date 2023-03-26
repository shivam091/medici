# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrder < ApplicationRecord
  belongs_to :store, inverse_of: :purchase_orders
  belongs_to :supplier, inverse_of: :purchase_orders
end
