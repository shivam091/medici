# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :downcase_attribute do |attribute|
  match do |record|
    expect(record.class.attributes_to_downcase).to include(attribute)
  end

  description do
    "check downcase_attribute configuration on class"
  end

  failure_message do |record|
    "expected to have downcase_attribute configuration on #{record.class} to include #{attribute}"
  end

  failure_message_when_negated do |record|
    "expected not to have downcase_attribute configuration on #{record.class} to include #{attribute}"
  end
end
