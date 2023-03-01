# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/create_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::CreateService, type: :service do
  let(:ingredient_attributes) { attributes_for(:ingredient) }
  subject { described_class.(ingredient_attributes) }

  describe "#call" do
    context "when ingredient is valid" do
      it "returns a success response with the ingredient" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Ingredient '#{subject.payload[:ingredient].name}' was successfully created.")
        expect(subject.payload).to include(ingredient: instance_of(::Ingredient))
      end

      include_examples "creates a new object", ::Ingredient
    end

    context "when ingredient is invalid" do
      let(:ingredient_attributes) { attributes_for(:ingredient, name: "") }

      it "returns an error response with the ingredient" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Ingredient could not be created.")
        expect(subject.payload).to include(ingredient: instance_of(::Ingredient))
      end

      include_examples "does not change count of objects", ::Ingredient
    end
  end
end
