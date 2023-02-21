# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

Dir.glob(File.dirname(__FILE__) + "/helpers/*.rb", &method(:require))

module BootstrapFormBuilder
  module Helpers

    include CheckBox
    include RadioButton
  
    include Errors

    def static_field_class
      "form-control-plaintext"
    end

    private

    def setup_css_class(the_class, options = {})
      if (extra_classes = options.delete(:extra_classes))
        the_class = [the_class, extra_classes].compact.join(" ")
      end
      options[:class] = the_class
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include BootstrapFormBuilder::Helpers
end
