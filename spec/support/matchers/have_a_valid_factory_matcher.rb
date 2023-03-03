# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :have_a_valid_factory do |factory_name|
  chain :with_associations do |associations|
    @associations = associations
  end

  chain :with_traits do |traits|
    @traits = traits
  end

  match do
    factory = (factory_name || described_class.table_name.singularize.to_sym)
    if @associations
      FactoryBot.build(factory, **@associations).should be_valid
    elsif @traits
      FactoryBot.build(factory, *@traits).should be_valid
    elsif @traits && @associations
      FactoryBot.build(factory, *@traits, **@associations).should be_valid
    else
      FactoryBot.build(factory).should be_valid
    end
  end

  description do
    "have valid factory"
  end

  failure_message do
    "expected #{described_class} to have valid factory"
  end

  failure_message_when_negated do
    "expected #{described_class} not to have valid factory"
  end
end
