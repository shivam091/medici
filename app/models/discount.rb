# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Discount < ApplicationRecord
  belongs_to :country, inverse_of: :discount
end
