# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumPurchaseOrderStatuses < Medici::Database::Migration[1.0]
  def change
    create_enum :purchase_order_statuses, [:pending, :incomplete, :received]
  end
end
