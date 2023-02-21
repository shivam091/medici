# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

require Rails.root.join("app/middlewares/ip_info.rb")

Medici::Application.config.middleware.insert 0, IpInfo, {ttl: 30, maxsize: 30}
