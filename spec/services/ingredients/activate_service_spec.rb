# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/activate_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::ActivateService, type: :service do
  describe "#call" do
    let(:ingredient) { create(:ingredient) }
    subject { described_class.(ingredient) }

    context "when activation is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' was successfully activated.")
        expect(subject.payload[:ingredient]).to eq(ingredient)
      end
    end

    context "when activation fails" do
      it "returns an error response" do
        allow(ingredient).to receive(:activate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' could not be activated.")
        expect(subject.payload[:ingredient]).to eq(ingredient)
      end
    end
  end
end
