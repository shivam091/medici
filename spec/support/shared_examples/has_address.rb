# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "has address" do
  describe "#address" do
    context "when address is not present" do
      it "builds a new address" do
        expect(subject.address).to be_a(::Address)
        expect(subject.address).to be_new_record
      end
    end

    context "when address is present" do
      let!(:address) { create(:address, :with_country, addressable: subject) }

      it "returns the existing address" do
        expect(subject.address).to eq(address)
      end
    end
  end
end
