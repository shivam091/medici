# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module Components
    module HelpText
      def generate_help(attribute_name, help_text)
        return if help_text == false

        help_klass ||= "form-text text-muted"
        help_text ||= get_help_text_by_i18n_key(attribute_name)
        help_tag ||= :small

        content_tag(help_tag, help_text, class: help_klass) if help_text.present?
      end

      def get_help_text_by_i18n_key(attribute_name)
        return unless object

        partial_scope = if object_class.respond_to?(:model_name)
                          object_class.model_name.name
                        else
                          object_class.name
                        end

        # First check for a subkey :html, as it is also accepted by i18n, and the
        # simple check for `attribute_name` would return an hash instead of a string (both
        # with .presence returning true!)
        help_text = nil
        ["#{attribute_name}.html", attribute_name, "#{attribute_name}_html"].each do |scope|
          break if help_text

          help_text = scoped_help_text(scope, partial_scope)
        end
        help_text
      end

      def object_class
        if !object.class.is_a?(ActiveModel::Naming) &&
           object.respond_to?(:klass) && object.klass.is_a?(ActiveModel::Naming)
          object.klass
        else
          object.class
        end
      end

      def scoped_help_text(attribute_name, partial_scope)
        underscored_scope = "activerecord.help_texts.#{partial_scope.underscore}"
        downcased_scope = "activerecord.help_texts.#{partial_scope.downcase}"

        help_text = translated_help_text(attribute_name, underscored_scope).presence

        help_text ||= if (text = translated_help_text(attribute_name, downcased_scope).presence)
                        warn "I18n key '#{downcased_scope}.#{attribute_name}' is deprecated, use '#{underscored_scope}.#{attribute_name}' instead"
                        text
                      end

        help_text
      end

      def translated_help_text(attribute_name, scope)
        ActiveSupport::SafeBuffer.new(I18n.t(attribute_name, scope: scope, default: ""))
      end
    end
  end
end
