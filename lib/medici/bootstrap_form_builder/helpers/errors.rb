# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module Helpers
    module Errors
      def input_with_error(attribute_name, &block)
        input = capture(&block)
        input << generate_error(attribute_name)
      end

      def errors_on(attribute_name, options = {})
        return unless is_invalid?(attribute_name)

        hide_attribute_name = options.fetch(:hide_attribute_name, false)
        custom_class = options.fetch(:custom_class, false)

        tag.div(class: custom_class || "invalid-tooltip") do
          if hide_attribute_name
            object.errors[attribute_name].to_sentence
          else
            field_errors = object.errors.full_messages_for(attribute_name)
            [*field_errors].to_sentence
          end
        end
      end
    end
  end
end
