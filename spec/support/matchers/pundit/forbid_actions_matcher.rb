# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Assert that actions are forbidden.
#
# ```
# describe MyPolicy do
#   let(:user) { User.new }
#   let(:record) { Record.new }
#   subject { described_class.new(user, record) }
#
#   context 'with a user that can perform the action' do
#     it { is_expected.to forbid_actions([:index, :new]) }
#   end
#
#   context 'with a user that cannot perform the action' do
#     it { is_expected.not_to forbid_actions([:show, :new]) }
#   end
# end
# ```

RSpec::Matchers.define :forbid_actions do |actions|
  match do |policy|
    actions.none? do |action|
      policy.public_send("#{action}?")
    end
  end

  description do
    "forbid actions #{actions} on the object"
  end

  failure_message do |_|
    "Expected user to not be able to perform actions #{actions}, but they can."
  end

  failure_message_when_negated do |_|
    "Expected user to be able to perform actions #{actions}, but they can."
  end
end
