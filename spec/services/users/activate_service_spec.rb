# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/users/activate_service_spec.rb

require "spec_helper"

RSpec.describe Users::ActivateService, type: :service do
  describe "#call" do
    let(:user) { create(:manager) }
    subject { described_class.(user) }

    context "when activation is successful" do
      it "activates the user" do
        expect { subject }.to change { user.reload.is_active? }.to(true)
        expect(subject.message).to eq("User '#{user.full_name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before { allow(user).to receive(:activate!).and_return(false) }

      it "does not activate the user" do
        expect { subject }.not_to change { user.reload.is_active? }
        expect(subject.message).to eq("User '#{user.full_name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
