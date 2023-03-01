# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :have_constant do |expected|
  match do |owner|
    ([Class, Module].include?(owner.class) ? owner : owner.class).const_defined?(expected)
  end

  description do
    "define the #{expected} constant"
  end

  failure_message do
    "expected #{described_class} to have constant #{expected}"
  end

  failure_message_when_negated do
    "expected #{described_class} not to have constant #{expected}"
  end
end
