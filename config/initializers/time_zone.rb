# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

# Set default time zone of active record
Medici::Application.config.active_record.default_timezone = :utc

# Set time zone of the application server
Time.zone = "Asia/Kolkata"
Time.zone_default = Time.zone
Medici::Application.config.time_zone = Time.zone
