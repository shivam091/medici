# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module FormGroup
    def form_group(*args, &block)
      options = args.extract_options!
      attribute_name = args.first

      label = generate_label(options[:id], attribute_name, options[:label], options[:label_col], options[:layout], options[:floating])
      help_text = generate_help(attribute_name, options[:help_text])

      options[:class] = form_group_classes(options)
      options.delete(:class) if options[:class].blank?

      if group_layout_horizontal?(options[:layout])
        tag.dl(**form_group_attrs(options)) do
          concat(label)
          concat(tag.div(class: form_group_control_class(options)) do
            prepend_and_append_input(attribute_name, options) do
              capture(&block)
            end + help_text
          end)
        end
      else
        if (options[:floating] || layout_floating?)
          tag.dl(**form_group_attrs(options)) do
            concat(prepend_and_append_input(attribute_name, options) do
              concat(tag.div(class: floating_label_classes(attribute_name)) do
                concat(capture(&block))
                concat(label)
              end)
            end)
            concat(help_text)
          end
        else
          tag.dl(**form_group_attrs(options)) do
            concat(label)
            concat(prepend_and_append_input(attribute_name, options) do
              capture(&block)
            end)
            concat(help_text)
          end
        end
      end
    end

    private

    def form_group_attrs(options)
      options.except(
        :id, :label, :help_text, :icon, :label_col, :control_col,
        :additional_control_col_class, :layout, :floating, :input_group
      )
    end

    def form_group_content_tag(attribute_name, field_name, tag_name, options, html_options)
      html_class = control_specific_class(tag_name)
      html_class = "#{html_class} col-auto g-3" if (@layout == :horizontal && options[:skip_inline].blank?)
      tag.dd(tag.div(class: html_class) do
        input_with_error(attribute_name) do
          send(tag_name, attribute_name, options, html_options)
        end
      end)
    end

    def floating_label_classes(attribute_name)
      classes = Array("form-floating")
      classes << "is-invalid" if is_invalid?(attribute_name)
      classes
    end

    def form_group_control_class(options)
      classes = [options[:control_col] || control_col]
      classes << options[:additional_control_col_class] if options[:additional_control_col_class]
      classes << offset_col(options[:label_col] || @label_col) unless options[:label]
      classes.flatten.compact.reject(&:blank?)
    end

    def form_group_classes(options)
      classes = options[:class] == false ? [] : (([*options[:class]&.split(/\s+/)]) | [form_group_default_class])
      classes << "row" if horizontal_group_with_gutters?(options[:layout], classes)
      classes << "col-auto g-3" if field_inline_override?(options[:layout])
      classes << options.delete(:wrapper_class) if options.key?(:wrapper_class)
      classes << options.dig(:wrapper, :class)
      classes << feedback_class if options[:icon]
      classes.compact.reject(&:blank?).presence
    end

    def form_group_default_class
      (layout == :inline ? "col" : "")
    end

    def horizontal_group_with_gutters?(layout, classes)
      group_layout_horizontal?(layout) && !classes_include_gutters?(classes)
    end

    def group_layout_horizontal?(layout)
      get_group_layout(layout) == :horizontal
    end

    def classes_include_gutters?(classes)
      classes.any? { |c| c =~ /^g-\d+$/ }
    end
  end
end
