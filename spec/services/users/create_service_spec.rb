# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/users/create_service_spec.rb

require "spec_helper"

RSpec.describe Users::CreateService, type: :service do
  let(:user_attributes) { attributes_for(:cashier, :with_address) }
  subject { described_class.(user_attributes) }

  describe "#call" do
    context "when user is valid" do
      it "sets flash message" do
        expect(subject.message).to eq("User 'Medici Cashier' was successfully created.")
      end

      include_examples "creates a new object", ::User

      include_examples "returns a success response"
    end

    context "when user is invalid" do
      let(:user_attributes) { attributes_for(:user, first_name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("User could not be created.")
      end

      include_examples "does not change count of objects", ::User

      include_examples "returns an error response"
    end
  end
end
