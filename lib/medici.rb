# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  base_path = File.expand_path("../medici", __FILE__)

  require base_path + "/bullet"
  require base_path + "/bootstrap_form_builder"
end
