# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/policies/medicine_policy_spec.rb

require "spec_helper"

RSpec.describe MedicinePolicy, type: :policy do
  let!(:medicine) { create(:medicine, :with_user, :active) }

  context "when admin is logged in" do
    let(:admin) { build(:admin, :with_store, :confirmed) }
    subject { described_class.new(admin, medicine) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to match_policy_scope(admin, [medicine]) }
  end

  context "when manager is logged in" do
    let(:manager) { build(:manager, :with_store, :confirmed) }
    subject { described_class.new(manager, medicine) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to forbid_action(:destroy) }

    it { is_expected.to match_policy_scope(manager, [medicine]) }
  end

  context "when cashier is logged in" do
    let(:cashier) { build(:cashier, :with_store, :confirmed) }
    subject { described_class.new(cashier, medicine) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }

    it { is_expected.to match_policy_scope(cashier, [medicine]) }
  end
end
