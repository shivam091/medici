# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/countries/activate_service_spec.rb

require "spec_helper"

RSpec.describe Countries::ActivateService, type: :service do
  describe "#call" do
    let(:country) { create(:country) }
    subject { described_class.(country) }

    context "when activation is successful" do
      it "activates the country" do
        expect { subject }.to change { country.reload.is_active? }.to(true)
      end

      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Country '#{country.name}' was successfully activated.")
      end
    end

    context "when activation fails" do
      before do
        allow(country).to receive(:activate!).and_return(false)
      end

      it "does not activate the country" do
        expect { subject }.not_to change { country.reload.is_active? }
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Country '#{country.name}' could not be activated.")
      end
    end
  end
end
