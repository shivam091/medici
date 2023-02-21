# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module Components
    module Labels
      def generate_label(id, attribute_name, options, custom_label_col, group_layout, floating)
        return if options.blank?

        # id is the caller's options[:id] at the only place this method is called.
        # The options argument is a small subset of the options that might have
        # been passed to generate_label's caller, and definitely doesn't include
        # :id.
        options[:for] = id if acts_like_form_tag

        options[:class] = label_classes(attribute_name, options, custom_label_col, group_layout, floating)
        options.delete(:class) if options[:class].none?

        label(attribute_name, label_text(attribute_name, options), options.except(:text))
      end

      def label_classes(attribute_name, options, custom_label_col, group_layout, floating)
        classes = [options[:class], label_layout_classes(custom_label_col, group_layout)]
        classes << "form-label" unless (floating || layout_floating?)

        case options.delete(:required)
        when true
          classes << "required"
        when nil, :default
          classes << "required" if required_attribute?(object, attribute_name)
        end
        classes << "is-invalid" if is_invalid?(attribute_name)
        classes << "text-danger" if label_errors
        classes.flatten.compact
      end

      def label_layout_classes(custom_label_col, group_layout)
        if layout_horizontal?(group_layout)
          ["col-form-label", (custom_label_col || label_col)]
        elsif layout_inline?(group_layout)
          ["me-sm-2"]
        end
      end

      def label_text(attribute_name, options)
        if label_errors && is_invalid?(attribute_name)
          (options[:text] || object.class.human_attribute_name(attribute_name)).to_s.concat(" #{get_error_messages(attribute_name)}")
        else
          options[:text] || object&.class.try(:human_attribute_name, attribute_name)
        end
      end
    end
  end
end
