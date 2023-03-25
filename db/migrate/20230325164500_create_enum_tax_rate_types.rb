# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumTaxRateTypes < Medici::Database::Migration[1.0]
  def change
    create_enum :tax_rate_types, [:vat, :gst, :cgst, :sgst, :pst, :hst, :st]
  end
end
