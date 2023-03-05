# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Assert that action is forbidden.
#
# ```
# describe MyPolicy do
#   let(:user) { User.new }
#   let(:record) { Record.new }
#   subject { described_class.new(user, record) }
#
#   context 'with a user that can perform the action' do
#     it { is_expected.to forbid_action(:index) }
#   end
#
#   context 'with a user that cannot perform the action' do
#     it { is_expected.not_to forbid_action(:show) }
#   end
# end
# ```

RSpec::Matchers.define :forbid_action do |action|
  match do |policy|
    !policy.public_send("#{action}?")
  end

  description do
    "forbid #{action} on the object"
  end

  failure_message do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for #{policy.user.inspect}."
  end
end
