# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/users/update_service_spec.rb

require "spec_helper"

RSpec.describe Users::UpdateService, type: :service do
  describe "#call" do
    let(:user) { create(:cashier) }
    let(:user_attributes) { attributes_for(:cashier, first_name: "New name") }
    subject { described_class.(user, user_attributes) }

    context "when update is successful" do
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:user]).to eq(user)
        expect(user.reload.full_name).to eq(user.full_name)
        expect(subject.message).to eq("User '#{user.full_name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(user).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("User could not be updated.")
        expect(subject.payload[:user]).to eq(user)
      end
    end
  end
end
