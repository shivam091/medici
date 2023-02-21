# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module Helpers
    module Buttons
      def button(value, options = {}, &block)
        classes = Array(options[:class]) << "btn"
        classes << "btn-#{options.delete(:size)}" if options[:size].in?([:sm, :lg])
        setup_css_class(classes.join(" "), options)
        super(value, options, &block)
      end

      def submit(value, options = {})
        classes = Array(options[:class]) << "btn"
        classes << "btn-#{options.delete(:size)}" if options[:size].in?([:sm, :lg])
        setup_css_class(classes.join(" "), options)

        layout == :inline ? form_group { super(value ,options) } : super(value ,options)
      end

      def primary(name = nil, options = {}, &block)
        options[:extra_classes] = "btn-primary"

        if options[:render_as_button] || block
          options.except!(:render_as_button)
          button(name, options, &block)
        else
          submit(name, options)
        end
      end

      def secondary(name = nil, options = {}, &block)
        options[:extra_classes] = "btn-secondary"

        if options[:render_as_button] || block
          options.except!(:render_as_button)
          button(name, options, &block)
        else
          submit(name, options)
        end
      end

      def danger(name = nil, options = {}, &block)
        options[:extra_classes] = "btn-danger"

        if options[:render_as_button] || block
          options.except!(:render_as_button)
          button(name, options, &block)
        else
          submit(name, options)
        end
      end
    end
  end
end
