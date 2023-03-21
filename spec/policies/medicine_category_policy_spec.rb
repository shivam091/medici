# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/policies/medicine_category_policy_spec.rb

require "spec_helper"

RSpec.describe MedicineCategoryPolicy, type: :policy do
  let(:medicine_category) { create(:medicine_category) }

  context "when super admin is logged in" do
    let(:super_admin) { build(:super_admin, :confirmed) }
    subject { described_class.new(super_admin, medicine_category) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to match_policy_scope(super_admin, [medicine_category]) }
  end

  context "when admin is logged in" do
    let(:admin) { build(:admin, :confirmed) }
    subject { described_class.new(admin, medicine_category) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to forbid_action(:destroy) }

    it { is_expected.to match_policy_scope(admin, [medicine_category]) }
  end

  context "when manager is logged in" do
    let(:manager) { build(:manager, :confirmed) }
    subject { described_class.new(manager, medicine_category) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }

    it { is_expected.to match_policy_scope(manager, []) }
  end

  context "when cashier is logged in" do
    let(:cashier) { build(:cashier, :confirmed) }
    subject { described_class.new(cashier, medicine_category) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }

    it { is_expected.to match_policy_scope(cashier, []) }
  end
end
