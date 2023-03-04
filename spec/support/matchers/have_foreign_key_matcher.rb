# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Asserts that the foreign key exists.
#
# ```
# RSpec.describe ModelName, type: :model do
#   it { is_expected.to have_foreign_key(:currency_id) }
#   it { is_expected.to have_foreign_key(:currency_id).with_name(:fk_countries_currency_id_on_currencies) }
#   it { is_expected.to have_foreign_key(:currency_id).on_delete(:restrict) }
#   it { is_expected.to have_foreign_key(:currency_id).with_name(:fk_countries_currency_id_on_currencies).on_delete(:restrict) }
# end
# ```

RSpec::Matchers.define :have_foreign_key do |column_name|
  chain :with_name do |identifier|
    @identifier = identifier
  end

  chain :on_delete do |on_delete|
    @on_delete = on_delete
  end

  match do |model|
    foreign_key = model.class.connection.foreign_keys(model.class.table_name).find do |foreign_key|
      foreign_key.column == column_name.to_s
    end
    options = foreign_key&.options

    if @identifier.present? && @on_delete.present?
      foreign_key.present? && options.present? && options[:name] == @identifier.to_s && options[:on_delete] == @on_delete
    elsif @identifier.present?
      foreign_key.present? && options.present? && options[:name] == @identifier.to_s
    elsif @on_delete.present?
      foreign_key.present? && options.present? && options[:on_delete] == @on_delete
    else
      foreign_key.present?
    end
  end

  description do |_|
    description = "have a foreign key on #{column_name}"

    if @identifier.present? && @on_delete.present?
      description << " with name #{@identifier} on_delete => #{@on_delete}"
    elsif @identifier.present?
      description << " with name #{@identifier}"
    elsif @on_delete.present?
      description << " on_delete => #{@on_delete}"
    end

    description
  end

  failure_message do |model|
    failure_message = "expected to have a foreign key on #{column_name}"

    if @identifier.present? && @on_delete.present?
      failure_message = " with name #{@identifier} on_delete => #{@on_delete}"
    elsif @identifier.present?
      failure_message = " with name #{@identifier}"
    elsif @on_delete.present?
      failure_message = " on_delete => #{@on_delete}"
    end

    failure_message
  end

  failure_message_when_negated do |model|
    failure_message_when_negated = "expected not to have a foreign key on #{column_name}"

    if @identifier.present? && @on_delete.present?
      failure_message_when_negated = " with name #{@identifier} on_delete => #{@on_delete}"
    elsif @identifier.present?
      failure_message_when_negated = " with name #{@identifier}"
    elsif @on_delete.present?
      failure_message_when_negated = " on_delete => #{@on_delete}"
    end

    failure_message_when_negated
  end
end
