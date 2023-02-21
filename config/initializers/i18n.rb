# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
Medici::Application.config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml,yaml}")]

# Whitelist locales available for the application
Medici::Application.config.i18n.available_locales = [:en]

# Set default locale of the application
# Rails will fallback to config.i18n.default_locale translation
Medici::Application.config.i18n.fallbacks = true

# fallbacks value can also be a hash - a map of fallbacks if you will
# missing translations of es and fr languages will fallback to english
# missing translations in german will fallback to french ("de" => "fr")
Medici::Application.config.i18n.fallbacks = {}

# Default application locale
I18n.default_locale = :en
