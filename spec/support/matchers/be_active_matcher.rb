# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :be_active do
  match do |object|
    object.is_active?
  end

  description do
    "active"
  end

  failure_message do |object|
    "expected #{object} to be active but was inactive"
  end

  failure_message_when_negated do |object|
    "expected #{object} to be inactive but was active"
  end
end
