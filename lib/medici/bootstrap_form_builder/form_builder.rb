# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require File.dirname(__FILE__) + "/form_group_builder"
require File.dirname(__FILE__) + "/form_group"
require File.dirname(__FILE__) + "/components"
require File.dirname(__FILE__) + "/inputs"

require File.dirname(__FILE__) + "/helpers"
require File.dirname(__FILE__) + "/helpers/buttons"
require File.dirname(__FILE__) + "/input_group_builder"

module BootstrapFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors,
                :label_errors, :acts_like_form_tag, :control_class,
                :error_style

    alias_method :datetime_select_without_bootstrap, :datetime_select
    alias_method :time_select_without_bootstrap, :time_select
    alias_method :date_select_without_bootstrap, :date_select

    include BootstrapFormBuilder::Helpers
    include BootstrapFormBuilder::Helpers::Buttons

    include BootstrapFormBuilder::FormGroupBuilder
    include BootstrapFormBuilder::FormGroup
    include BootstrapFormBuilder::Components

    include BootstrapFormBuilder::Inputs
    include BootstrapFormBuilder::InputGroupBuilder

    delegate :content_tag, :capture, :concat, :tag, to: :@template

    def initialize(object_name, object, template, options)
      @layout = options[:layout] || default_layout
      @label_col = options[:label_col] || default_label_col
      @control_col = options[:control_col] || default_control_col
      @label_errors = options[:label_errors] || false

      @inline_errors = if options[:inline_errors].nil?
                         @label_errors != true
                       else
                         options[:inline_errors] != false
                       end
      @acts_like_form_tag = options[:acts_like_form_tag]

      @error_style = options[:error_style] || error_style

      add_default_form_attributes_and_form_inline(options)
      super
    end

    def add_default_form_attributes_and_form_inline(options)
      options[:html] ||= {}
      options[:html].reverse_merge!(BootstrapFormBuilder.config.default_form_attributes)

      if options[:layout].eql?(:inline)
        options[:html][:class] =
          ([*options[:html][:class]&.split(/\s+/)] | %w[row row-cols-auto g-3 align-items-center])
          .compact.join(" ")
      elsif options[:layout].eql?(:default) || default_layout.eql?(:default)
        options[:html][:class] =
          [*options[:html][:class]&.split(/\s+/)].compact.join(" ")
      else
        return
      end
    end

    def fields_for(record_name, record_object = nil, fields_options = {}, &block)
      @layout = fields_options[:layout] || default_layout
      fields_options = fields_for_options(record_object, fields_options)
      record_object = nil if record_object.is_a?(Hash) && record_object.extractable_options?
      super(record_name, record_object, fields_options, &block)
    end

    # the Rails `fields` method passes its options
    # to the builder, so there is no need to write a `bootstrap_form` helper
    # for the `fields` method.

    private

    def fields_for_options(record_object, fields_options)
      field_options = fields_options
      field_options = record_object if record_object.is_a?(Hash) && record_object.extractable_options?
      %i[layout control_col inline_errors label_errors].each do |option|
        field_options[option] ||= options[option]
      end
      field_options[:label_col] = field_options[:label_col].present? ? (field_options[:label_col]).to_s : options[:label_col]
      field_options
    end

    def default_layout
      # :default, :horizontal, floating, or :inline
      :default
    end

    def default_label_col
      "col-sm-2"
    end

    def error_style
      "inline-text"
    end

    def offset_col(label_col)
      label_col.gsub(/\bcol-(\w+)-(\d)\b/, 'offset-\1-\2')
    end

    def default_control_col
      "col-sm-10"
    end

    def hide_class
      "visually-hidden" # still accessible for screen readers
    end

    def control_class
      "form-control"
    end

    def feedback_class
      "has-feedback"
    end

    def control_specific_class(method)
      "rails-bootstrap-forms-#{method.to_s.tr('_', '-')}"
    end
  end
end
