# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# Helper module containing methods for internationalization of enums.
#
module EnumsHelper
  # Returns an array of the possible key/i18n values for the enum
  # Example usage:
  # enum_options_for_select(UserPreference, :indent_mode)
  def enum_options_for_select(class_name, enum)
    class_name.send(enum.to_s.pluralize).map do |key, value|
      [enum_i18n(class_name, enum, key), value]
    end
  end

  # Returns the i18n version the models current enum key
  # Example usage:
  # enum_l(user_preference, :indent_mode)
  def enum_l(model, enum)
    enum_i18n(model.class, enum, model.send(enum))
  end

  # Returns the i18n string for the enum key
  # Example usage:
  # enum_i18n(UserPreference, :indent_mode, :spaces)
  def enum_i18n(class_name, enum, key)
    I18n.t("#{key}", scope: "enumerations.#{class_name.model_name.i18n_key}.#{enum.to_s.pluralize}")
  end
end
