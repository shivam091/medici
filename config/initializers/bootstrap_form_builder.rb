# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

BootstrapFormBuilder.configure do |config|
  # to make forms non-compliant with W3C.
  config.default_form_attributes = {role: "form", novalidate: true}
end
