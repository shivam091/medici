# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/users/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Users::DestroyService, type: :service do
  describe "#call" do
    let!(:user) { create(:cashier) }
    subject { described_class.(user) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::User

      it "sets flash message" do
        expect(subject.message).to eq("User 'Medici Cashier' was successfully destroyed.")
        expect(::User.find_by(id: user.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(user).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::User

      it "sets flash message" do
        expect(subject.message).to eq("User 'Medici Cashier' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
