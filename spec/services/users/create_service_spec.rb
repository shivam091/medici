# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/users/create_service_spec.rb

require "spec_helper"

RSpec.describe Users::CreateService, type: :service do
  let(:user_attributes) { attributes_for(:cashier) }
  subject { described_class.(user_attributes) }

  describe "#call" do
    context "when user is valid" do
      it "returns a success response with the user" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("User '#{subject.payload[:user].full_name}' was successfully created.")
        expect(subject.payload).to include(user: instance_of(::User))
      end

      include_examples "creates a new object", ::User
    end

    context "when user is invalid" do
      let(:user_attributes) { attributes_for(:user, first_name: "") }

      it "returns an error response with the user" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("User could not be created.")
        expect(subject.payload).to include(user: instance_of(::User))
      end

      include_examples "does not change count of objects", ::User
    end
  end
end
