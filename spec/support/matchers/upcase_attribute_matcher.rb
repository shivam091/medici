# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :upcase_attribute do |attribute|
  match do |record|
    expect(record.class.attributes_to_upcase).to include(attribute)
  end

  description do
    "check upcase_attribute configuration on class"
  end

  failure_message do |record|
    "expected to have upcase_attribute configuration on #{record.class} to include #{attribute}"
  end

  failure_message_when_negated do |record|
    "expected not to have upcase_attribute configuration on #{record.class} to include #{attribute}"
  end
end
