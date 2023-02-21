# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module Inputs
    FLOATING_INPUT_FIELDS = %i(
      text_field
      url_field
      search_field
      telephone_field
      number_field
      email_field
      phone_field
      password_field
      text_area
    )

    PICKER_INPUT_FIELDS = %i(
      datetime_local_field
      date_field
      datetime_field
      time_field
      month_field
      week_field
    )

    (FLOATING_INPUT_FIELDS + PICKER_INPUT_FIELDS).each do |method_name|
      define_method(method_name) do |attribute_name, options = {}|
        label_options = options.fetch(:label, {})
        options.reverse_merge!(onclick: "this.showPicker();") if method_name.in?(PICKER_INPUT_FIELDS)

        form_group_builder(attribute_name, options) do
          if (layout_floating? || options.delete(:floating))
            options[:placeholder] ||= label_text(attribute_name, label_options)
          end
          super(attribute_name, options)
        end
      end
    end

    %i(date_select datetime_select time_select).each do |method_name|
      define_method(method_name) do |attribute_name, options = {}, html_options = {}|
        html_options = html_options.reverse_merge(control_class: "form-select")
        form_group_builder(attribute_name, options, html_options) do
          form_group_content_tag(attribute_name, attribute_name, "#{method_name.to_s}_without_bootstrap", options, html_options)
        end
      end
    end

    %i(range_field file_field color_field).each do |method_name|
      define_method(method_name) do |attribute_name, options = {}|
        if method_name.eql?(:range_field)
          options = options.reverse_merge(control_class: "form-range")
        elsif method_name.eql?(:file_field)
          options = options.reverse_merge(control_class: "form-control form-control-file")
        elsif method_name.eql?(:color_field)
          options = options.reverse_merge(control_class: "form-control form-control-color")
        end

        form_group_builder(attribute_name, options) do
          super(attribute_name, options)
        end
      end
    end

    def select(attribute_name, choices = nil, options = {}, html_options = {}, &block)
      label_options = options.fetch(:label, {})
      html_options = html_options.reverse_merge(control_class: "form-select")

      form_group_builder(attribute_name, options, html_options) do
        if (options.delete(:floating) || layout_floating?)
          html_options[:placeholder] ||= label_text(attribute_name, label_options)
        end
        super(attribute_name, choices, options, html_options, &block)
      end
    end

    def time_zone_select(attribute_name, priority_zones = nil, options = {}, html_options = {})
      html_options = html_options.reverse_merge(control_class: "form-select")
      form_group_builder(attribute_name, options, html_options) do
        super(attribute_name, priority_zones, options, html_options)
      end
    end

    def grouped_collection_select(attribute_name, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      html_options = html_options.reverse_merge(control_class: "form-select")
      form_group_builder(attribute_name, options, html_options) do
        super(attribute_name, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
      end
    end

    def collection_select(attribute_name, collection, value_method, text_method, options = {}, html_options = {})
      html_options = html_options.reverse_merge(control_class: "form-select")
      form_group_builder(attribute_name, options, html_options) do
        super(attribute_name, collection, value_method, text_method, options, html_options)
      end
    end

    def check_box(attribute_name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      options = options.symbolize_keys!
      opts = {}
      check_box_options = options.except(:class, :label, :label_class, :error_message, :help_text,
                                         :inline, :hide_label, :skip_label, :wrapper, :wrapper_class, :switch)
      check_box_options[:class] = check_box_classes(attribute_name, options)

      no_wrapper = options[:wrapper] == false
      wrapper_options = options[:wrapper] || {}

      check_box_field = super(attribute_name, check_box_options, checked_value, unchecked_value)
      check_box_help_text = generate_help(attribute_name, options.delete(:help_text))

      check_box_field.concat(check_box_label(attribute_name, options, checked_value, &block)) unless options[:skip_label]
      check_box_field.concat(generate_error(attribute_name)) if options[:error_message]
      check_box_field.concat(tag.dd(check_box_help_text)) if check_box_help_text.present?

      check_box_html = if no_wrapper
        check_box_field
      else
        form_group_classes = Array(options[:class])
        form_group_classes << options.dig(:wrapper, :class).presence unless no_wrapper
        form_group_classes << options.delete(:wrapper_class) if options.key?(:wrapper_class)
        opts[:class] = form_group_classes.presence if form_group_classes.present?

        tag.dl(opts) do
          concat(tag.dt(class: check_box_wrapper_class(options), **wrapper_options.except(:class)) do
            concat(check_box_field)
          end)
        end
      end

      check_box_html
    end

    def collection_check_boxes(*args)
      html = inputs_collection(*args) do |attribute_name, value, options|
        options[:multiple] = true
        check_box(attribute_name, options, value, nil)
      end

      if args.extract_options!.symbolize_keys!.delete(:include_hidden) { true }
        html.prepend(hidden_field(args.first, value: "", multiple: true))
      end
      html
    end

    def collection_radio_buttons(*args)
      inputs_collection(*args) do |attribute_name, value, options|
        radio_button(attribute_name, value, options)
      end
    end

    def hidden_field(*args)
      options = args.extract_options!
      attribute_name = args.first

      options[:value] = object.send(attribute_name) unless options.key?(:value)

      super(attribute_name, options)
    end

    def radio_button(attribute_name, value, *args)
      options = args.extract_options!.symbolize_keys!
      wrapper_attributes = options[:wrapper] || {}
      wrapper_attributes[:class] = radio_button_wrapper_class(options)
      tag.div(**wrapper_attributes) do
        html = super(attribute_name, value, radio_button_options(attribute_name, options))
        html.concat(radio_button_label(attribute_name, value, options)) unless options[:skip_label]
        html.concat(generate_error(attribute_name)) if options[:error_message]
        html
      end
    end

    def rich_text_area(attribute_name, options = {})
      form_group_builder(attribute_name, options) do
        options[:class] = ["trix-content", options[:class]].compact.join(" ")
        super(attribute_name, options)
      end
    end

    def static_field(*args)
      options = args.extract_options!
      attribute_name = args.first

      static_options = options.merge(
        readonly: true,
        control_class: [options[:control_class], static_field_class].compact
      )

      static_options[:value] = object.send(attribute_name) unless static_options.key?(:value)

      text_field(attribute_name, static_options)
    end

    def label(attribute_name, content = nil, options = {}, &block)
      content = block ? capture(&block) : content
      classes = options.fetch(:class, [])
      options[:class] = classes
      super(attribute_name, content, options, &block)
    end

    private

    def inputs_collection(attribute_name, collection, value, text, options = {})
      options[:inline] ||= layout_inline?(options[:layout])

      form_group_builder(attribute_name, options) do
        inputs = ActiveSupport::SafeBuffer.new

        collection.each_with_index do |object, i|
          input_value = value.respond_to?(:call) ? value.call(object) : object.send(value)
          input_options = form_group_collection_input_options(options, text, object, i, input_value, collection)
          inputs << yield(attribute_name, input_value, input_options)
        end

        inputs
      end
    end

    # FIXME: Find a way to reduce the parameter list size
    def form_group_collection_input_options(options, text, object, index, input_value, collection)
      input_options = options.merge(label: text.respond_to?(:call) ? text.call(object) : object.send(text))
      if (checked = input_options[:checked])
        input_options[:checked] = form_group_collection_input_checked?(checked, object, input_value)
      end

      input_options[:error_message] = (index == collection.size - 1)
      input_options.except!(:class)
      input_options
    end

    def form_group_collection_input_checked?(checked, object, input_value)
      checked == input_value ||
        Array(checked).try(:include?, input_value) ||
        checked == object ||
        Array(checked).try(:include?, object)
    end
  end
end
