# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

Rails.application.config.action_controller.asset_host = Rails.application.credentials.config[:DOMAIN]

Rails.application.config.assets.css_compressor = :sass

Rails.application.config.assets.debug = true

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

Rails.application.config.assets.precompile += %w(
  .svg
  bootstrap.min.js
  popper.js
)
