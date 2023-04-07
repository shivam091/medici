# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/policies/currency_policy_spec.rb

require "spec_helper"

RSpec.describe CurrencyPolicy, type: :policy do
  let!(:currency) { create(:currency, :active) }

  context "when admin is logged in" do
    let(:admin) { build(:admin, :confirmed) }
    subject { described_class.new(admin, currency) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:active) }
    it { is_expected.to permit_action(:inactive) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
    it { is_expected.to permit_action(:activate) }
    it { is_expected.to permit_action(:deactivate) }

    it { is_expected.to match_policy_scope(admin, [currency]) }
  end

  context "when manager is logged in" do
    let(:manager) { build(:manager, :confirmed) }
    subject { described_class.new(manager, currency) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:active) }
    it { is_expected.to forbid_action(:inactive) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action(:activate) }
    it { is_expected.to forbid_action(:deactivate) }

    it { is_expected.to match_policy_scope(manager, []) }
  end

  context "when cashier is logged in" do
    let(:cashier) { build(:cashier, :confirmed) }
    subject { described_class.new(cashier, currency) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:active) }
    it { is_expected.to forbid_action(:inactive) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action(:activate) }
    it { is_expected.to forbid_action(:deactivate) }

    it { is_expected.to match_policy_scope(cashier, []) }
  end
end
