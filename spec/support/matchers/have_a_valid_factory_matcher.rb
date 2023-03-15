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
      expect(FactoryBot.build(factory, **@associations)).to be_valid
    elsif @traits
      expect(FactoryBot.build(factory, *@traits)).to be_valid
    elsif @traits && @associations
      expect(FactoryBot.build(factory, *@traits, **@associations)).to be_valid
    else
      expect(FactoryBot.build(factory)).to be_valid
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
