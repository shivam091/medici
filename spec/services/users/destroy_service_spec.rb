# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/users/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Users::DestroyService, type: :service do
  describe "#call" do
    let(:user) { create(:cashier) }
    subject { described_class.(user) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("User '#{user.full_name}' was successfully destroyed.")
        expect(subject.payload[:user]).to eq(user)
        expect(::User.find_by(id: user.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before do
        allow(user).to receive(:destroy).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("User '#{user.full_name}' could not be destroyed.")
        expect(subject.payload[:user]).to eq(user)
      end

      include_examples "does not change count of objects", ::User
    end
  end
end
