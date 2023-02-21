# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class EnableUuid < Medici::Database::Migration[1.0]
  enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
end
