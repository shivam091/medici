# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

Medici::Application.config.secret_key_base = Rails.application.credentials.config[:SECRET_KEY_BASE]
