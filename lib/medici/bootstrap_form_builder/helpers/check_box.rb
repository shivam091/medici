# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module Helpers
    module CheckBox
      private

      def check_box_label(attribute_name, options, checked_value, &block)
        label_name = if options[:multiple]
                       check_box_value(attribute_name, checked_value)
                     else
                       attribute_name
                     end
        label_options = {class: check_box_label_class(attribute_name, options)}
        label_options[:for] = options[:id] if options[:id].present?
        label(label_name, check_box_description(attribute_name, options, &block), label_options)
      end

      def check_box_description(attribute_name, options, &block)
        content = block ? capture(&block) : options[:label]
        content || object&.class&.human_attribute_name(attribute_name) || attribute_name.to_s.humanize
      end

      def check_box_value(attribute_name, value)
        # label's `for` attribute needs to match checkbox tag's id,
        # IE sanitized value, IE
        # https://github.com/rails/rails/blob/5-0-stable/actionview/lib/action_view/helpers/tags/base.rb#L123-L125
        "#{attribute_name}_#{value.to_s.gsub(/\s/, "_").gsub(/[^-[[:word:]]]/, "").mb_chars.downcase}"
      end

      def check_box_classes(attribute_name, options)
        classes = Array(options[:class]) << "form-check-input"
        classes << "is-invalid" if is_invalid?(attribute_name)
        classes << "position-static" if (options[:skip_label] || options[:hide_label])
        classes.flatten.compact
      end

      def check_box_label_class(attribute_name, options)
        classes = Array(options[:class]) << "form-check-label"
        classes << options[:label_class]
        classes << "required" if required_attribute?(object, attribute_name) && !options[:multiple]
        classes << hide_class if options[:hide_label]
        classes.flatten.compact
      end

      def check_box_wrapper_class(options)
        classes = Array(options[:class]) << "form-check"
        classes << "form-check-inline" if layout_inline?(options[:inline])
        classes << "form-switch" if options[:switch]
        # classes << "mb-3" unless options[:multiple] || layout.eql?(:horizontal) || options.dig(:wrapper).eql?(false)
        classes.flatten.compact
      end
    end
  end
end
