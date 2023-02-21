# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module Helpers
    module RadioButton
      private

      def radio_button_options(attribute_name, options)
        radio_button_options = options.except(:class, :label, :label_class, :error_message, :help_text,
                                              :inline, :hide_label, :skip_label, :wrapper, :wrapper_class)
        radio_button_options[:class] = radio_button_classes(attribute_name, options)
        radio_button_options
      end

      def radio_button_label(attribute_name, value, options)
        label_options = {value: value, class: radio_button_label_class(options)}
        label_options[:for] = options[:id] if options[:id].present?
        label(attribute_name, options[:label], label_options)
      end

      def radio_button_classes(attribute_name, options)
        classes = Array(options[:class]) << "form-check-input"
        classes << "is-invalid" if is_invalid?(attribute_name)
        classes << "position-static" if (options[:skip_label] || options[:hide_label])
        classes.flatten.compact
      end

      def radio_button_label_class(options)
        classes = Array(options[:class]) << "form-check-label"
        classes << options[:label_class]
        classes << hide_class if options[:hide_label]
        classes.flatten.compact
      end

      def radio_button_wrapper_class(options)
        classes = Array(options[:class]) << "form-check"
        classes << "form-check-inline" if layout_inline?(options[:inline])
        classes << "disabled" if options[:disabled]
        classes << options.dig(:wrapper, :class).presence
        classes << options[:wrapper_class].presence
        classes.flatten.compact
      end
    end
  end
end
