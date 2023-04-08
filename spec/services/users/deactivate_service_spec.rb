# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/users/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Users::DeactivateService, type: :service do
  describe "#call" do
    let(:user) { create(:manager, :active) }
    subject { described_class.(user) }

    context "when deactivation is successful" do
      it "deactivates the user" do
        expect { subject }.to change { user.reload.is_active? }.to(false)
        expect(subject.message).to eq("User '#{user.full_name}' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before { allow(user).to receive(:deactivate!).and_return(false) }

      it "does not deactivate the user" do
        expect { subject }.not_to change { user.reload.is_active? }
        expect(subject.message).to eq("User '#{user.full_name}' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
