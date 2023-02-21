# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

ActiveRecord::Base.time_zone_aware_types << :tsrange
ActiveRecord::Base.time_zone_aware_types << :tstzrange

Medici::Application.config.active_record.automatic_scope_inversing = true
