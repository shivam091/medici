# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Replenishment < ApplicationRecord
  self.primary_key = :variant_id

  attribute :quantity_pending_from_supplier, default: 0

  belongs_to :medicine, inverse_of: :replenishment
end
