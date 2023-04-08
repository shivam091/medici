# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/profiles/update_service_spec.rb

require "spec_helper"

RSpec.describe Profiles::UpdateService, type: :service do
  describe "#call" do
    let(:user) { create(:cashier) }
    let(:user_attributes) { attributes_for(:cashier, first_name: "First", last_name: "Last") }
    subject { described_class.(user, user_attributes) }

    context "when update is successful" do
      it "updates the user" do
        expect(subject.payload[:user].full_name).to eq("First Last")
        expect(subject.message).to eq("Your profile was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(user).to receive(:update).and_return(false) }

      it "does not update the user" do
        expect(subject.payload[:user].full_name).to eq("Medici Cashier")
        expect(subject.message).to eq("Your profile could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
