# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

Medici::Application.config.generators do |generator|
  generator.orm :active_record, primary_key_type: :uuid
end
