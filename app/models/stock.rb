# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Stock < ApplicationRecord
  self.primary_key = :medicine_id

  attribute :quantity_in_hand, default: 0

  belongs_to :medicine, inverse_of: :stock
end
