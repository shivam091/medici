# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Current < ActiveSupport::CurrentAttributes
  attribute :user

  resets { user = nil }
end
