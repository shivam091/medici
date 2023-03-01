# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :be_one_of do |collection|
  match do |item|
    expect(collection).to include(item)
  end

  description do
    "check if item is one of #{collection}"
  end

  failure_message do |item|
    "expected #{item} to be one of #{collection}"
  end

  failure_message_when_negated do |item|
    "expected #{item} not to be one of #{collection}"
  end
end
