# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

Dir.glob(File.dirname(__FILE__) + "/components/*.rb", &method(:require))

module BootstrapFormBuilder
  module Components
    include HelpText
    include Labels
    include Layout
    include Errors
  end
end
