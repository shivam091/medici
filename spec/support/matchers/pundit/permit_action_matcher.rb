# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Assert that action is permitted.
#
# ```
# describe MyPolicy do
#   let(:user) { User.new }
#   let(:record) { Record.new }
#   subject { described_class.new(user, record) }
#
#   context 'with a user that can perform the action' do
#     it { is_expected.to permit_action(:index) }
#   end
#
#   context 'with a user that cannot perform the action' do
#     it { is_expected.not_to permit_action(:show) }
#   end
# end
# ```

RSpec::Matchers.define :permit_action do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  description do
    "permit #{action} on the object"
  end

  failure_message do |_|
    "Expected user to be able to perform action #{action}, but they can't."
  end

  failure_message_when_negated do |_|
    "Expected user to not be able to perform action #{action}, but they can't."
  end
end
