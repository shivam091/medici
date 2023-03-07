# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

ActionMailer::Base.smtp_settings = {
  address: "smtp.sendgrid.net",
  port: 587,
  user_name: Rails.application.credentials.config[:SENDGRID_USERNAME],
  password: Rails.application.credentials.config[:SENDGRID_PASSWORD],
  domain: Rails.application.credentials.config[:DOMAIN],
  authentication: :plain,
  enable_starttls_auto: true
}

ActionMailer::Base.perform_deliveries = true
