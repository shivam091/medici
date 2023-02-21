# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require File.dirname(__FILE__) + "/components"

module BootstrapFormBuilder
  module FormGroupBuilder
    include BootstrapFormBuilder::Components

    def form_group_builder(attribute_name, options, html_options = nil, &block)
      no_wrapper = options[:wrapper] == false

      options = form_group_builder_options(options, attribute_name)

      form_group_options = form_group_options(options, form_group_css_options(attribute_name, html_options.try(:symbolize_keys!), options))

      options.except!(
        :help_text, :icon, :label_col, :control_col, :additional_control_col_class, :layout, :skip_label, :label, :label_class,
        :hide_label, :skip_required, :label_as_placeholder, :wrapper_class, :wrapper, :input_group
      )

      if no_wrapper
        yield
      else
        form_group(attribute_name, form_group_options, &block)
      end
    end

    def form_group_builder_options(options, attribute_name)
      options.symbolize_keys!
      options = convert_form_tag_options(attribute_name, options) if @acts_like_form_tag
      options[:required] = form_group_required(options) if !options[:skip_label] && options.key?(:skip_required)
      options
    end

    def convert_form_tag_options(attribute_name, options = {})
      unless @options[:skip_default_ids]
        options[:name] ||= attribute_name
        options[:id] ||= attribute_name
      end
      options
    end

    def form_group_options(options, css_options)
      wrapper_options = options[:wrapper]
      form_group_options = {
        id: options[:id],
        help_text: options[:help_text],
        icon: options[:icon],
        label_col: options[:label_col],
        control_col: options[:control_col],
        additional_control_col_class: options[:additional_control_col_class],
        layout: get_group_layout(options[:layout]),
        class: options[:wrapper_class],
        floating: options[:floating],
        input_group: options.fetch(:input_group, {})
      }

      form_group_options.merge!(wrapper_options) if wrapper_options.is_a?(Hash)
      form_group_options[:label] = form_group_label(options, css_options) unless options[:skip_label]
      form_group_options
    end

    def form_group_label(options, css_options)
      {
        text: form_group_label_text(options[:label]),
        class: form_group_label_class(options),
        required: options[:required]
      }.merge(css_options[:id].present? ? { for: css_options[:id] } : {})
    end

    def form_group_label_text(label)
      text = label[:text] if label.is_a?(Hash)
      text ||= label if label.is_a?(String)
      text
    end

    def form_group_label_class(options)
      return hide_class if options[:hide_label] || options[:label_as_placeholder]

      classes = options[:label][:class] if options[:label].is_a?(Hash)
      classes ||= options[:label_class]
      classes
    end

    def form_group_required(options)
      return unless options.key?(:skip_required)

      warn "`:skip_required` is deprecated, use `:required: false` instead"
      options[:skip_required] ? false : :default
    end

    def form_group_css_options(attribute_name, html_options, options)
      css_options = html_options || options
      # Add control_class; allow it to be overridden by :control_class option
      control_classes = [css_options.delete(:control_class) { control_class }, options.delete(:additional_control_class)]
      css_options[:class] = [control_classes, css_options[:class]].compact.reject(&:blank?)
      css_options[:class] << "is-invalid" if is_invalid?(attribute_name)
      css_options[:placeholder] = form_group_placeholder(options, attribute_name) if options[:label_as_placeholder]
      css_options
    end

    def form_group_placeholder(options, attribute_name)
      form_group_label_text(options[:label]) || object.class.human_attribute_name(attribute_name)
    end
  end
end
