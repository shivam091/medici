# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Assert that actions are permitted.
#
# ```
# describe MyPolicy do
#   let(:user) { User.new }
#   let(:record) { Record.new }
#   subject { described_class.new(user, record) }
#
#   context 'with a user that can perform the action' do
#     it { is_expected.to permit_actions([:index, :new]) }
#   end
#
#   context 'with a user that cannot perform the action' do
#     it { is_expected.not_to permit_actions([:show, :new]) }
#   end
# end
# ```

RSpec::Matchers.define :permit_actions do |actions|
  match do |policy|
    actions.all? do |action|
      policy.public_send("#{action}?")
    end
  end

  description do
    "permit actions #{actions} on the object"
  end

  failure_message do |_|
    "Expected user to be able to perform actions #{actions}, but they can't."
  end

  failure_message_when_negated do |_|
    "Expected user to not be able to perform actions #{actions}, but they can't."
  end
end
