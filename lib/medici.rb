# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  base_path = File.expand_path("../medici", __FILE__)

  require base_path + "/bullet"
  require base_path + "/bootstrap_form_builder"
  require base_path + "/utils"
  require base_path + "/favicon"
  require base_path + "/regex"
  require base_path + "/i18n"
  require base_path + "/database/migration"
  require base_path + "/sql/functions"
end
