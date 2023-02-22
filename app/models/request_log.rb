# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class RequestLog < ApplicationRecord
  include Sortable, Filterable, UpcaseAttribute

  upcase_attributes! :method

  belongs_to :user, optional: true

  default_scope -> { order_created_desc }
end
