# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :strip_attribute do |attribute|
  match do |record|
    expect(record.class.attributes_to_strip).to include(attribute)
  end

  description do
    "check strip_attribute configuration on class"
  end

  failure_message do |record|
    "expected to have strip_attribute configuration on #{record.class} to include #{attribute}"
  end

  failure_message_when_negated do |record|
    "expected not to have strip_attribute configuration on #{record.class} to include #{attribute}"
  end
end
