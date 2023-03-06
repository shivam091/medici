# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

@twillo_client = Twilio::REST::Client.new(
  Rails.application.credentials.config[:TWILLO_ACCOUNT_SID],
  Rails.application.credentials.config[:TWILLO_AUTH_TOKEN]
)
