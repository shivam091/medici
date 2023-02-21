# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module BootstrapFormBuilder
  module Components
    module Errors
      def is_invalid?(attribute_name)
        attribute_name && object.respond_to?(:errors) && object.errors[attribute_name].any?
      end

      def required_attribute?(obj, attribute_name)
        return false unless obj && attribute_name

        target = obj.instance_of?(Class) ? obj : obj.class

        return false unless target.respond_to? :validators_on

        presence_validator?(target_validators(target, attribute_name))
      end

      def target_validators(target, attribute_name)
        target_validators = target.validators_on(attribute_name).map(&:class)
        # target_validators.concat target.validators_on(attribute_name[0..-4]).map(&:class) if attribute_name.end_with?("_id")
        target_validators
      end

      def presence_validator?(target_validators)
        has_presence_validator = target_validators.include?(
          ActiveModel::Validations::PresenceValidator
        )

        if defined? ActiveRecord::Validations::PresenceValidator
          has_presence_validator |= target_validators.include?(
            ActiveRecord::Validations::PresenceValidator
          )
        end

        has_presence_validator
      end

      def inline_is_invalid?(attribute_name)
        is_invalid?(attribute_name) && inline_errors
      end

      def generate_error(attribute_name)
        return unless inline_is_invalid?(attribute_name)

        error_text = get_error_messages(attribute_name)
        error_klass = @error_style.eql?("tooltip") ? "invalid-tooltip" : "invalid-feedback"
        error_text_tag = :div

        content_tag(error_text_tag, error_text, class: error_klass)
      end

      def get_error_messages(attribute_name)
        # messages = object.errors[name]
        # messages.concat object.errors[name[0..-4]] if name.end_with?("_id")
        # messages.join(", ")
        field_errors = object.errors.full_messages_for(attribute_name)
        [*field_errors].to_sentence
      end
    end
  end
end
