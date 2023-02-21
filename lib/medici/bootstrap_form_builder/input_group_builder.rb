# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module InputGroupBuilder
    def prepend_and_append_input(attribute_name, options, &block)
      input_group_options = options.fetch(:input_group, {})
      options = input_group_options.extract!(:prepend, :append, :input_group_class, :size)

      input = capture(&block) || ActiveSupport::SafeBuffer.new

      input = attach_input(options, :prepend) + input + attach_input(options, :append)
      input += generate_error(attribute_name)
      options.present? &&
        input = tag.div(input, class: input_group_classes(attribute_name, options))
      input
    end

    private

    def input_group_classes(attribute_name, options)
      classes = Array("input-group")
      classes << "is-invalid" if is_invalid?(attribute_name)
      classes << "input-group-#{options.delete(:size)}" if options[:size].in?([:sm, :lg])
      classes << options.delete(:input_group_class) if options[:input_group_class]
      # Require `has-validation` class to be added in addition to `input-group` if field has errors.
      classes << "has-validation" if is_invalid?(attribute_name)
      classes.compact
    end

    def attach_input(options, key)
      tags = [*options[key]].map do |item|
        input_group_content(item)
      end
      ActiveSupport::SafeBuffer.new(tags.join)
    end

    def input_group_content(content)
      return content if /btn/.match?(content)

      tag.span(content, class: "input-group-text")
    end
  end
end
