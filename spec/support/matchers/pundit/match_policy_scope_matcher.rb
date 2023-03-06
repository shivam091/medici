# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :match_policy_scope do |user, expected_scope|
  match do |policy|
    actual_scope = policy.class::Scope.new(user, policy.record.class).resolve
    actual_scope.to_a == expected_scope.to_a
  end

  description do
    "match the policy scope"
  end

  failure_message do |actual_scope|
    "expected the policy scope to return #{expected_scope}"
  end

  failure_message_when_negated do |actual_scope|
    "expected the policy scope not to return #{expected_scope}, but it did"
  end
end
