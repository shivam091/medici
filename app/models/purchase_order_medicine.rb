# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderMedicine < ApplicationRecord
  belongs_to :purchase_order, inverse_of: :purchase_order_medicines, touch: true
  belongs_to :medicine, inverse_of: :purchase_order_medicines
end
