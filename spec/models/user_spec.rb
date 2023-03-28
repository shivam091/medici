# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/user_spec.rb

require "spec_helper"

RSpec.describe User, type: :model do

  subject(:user) { build(:admin, :confirmed) }

  describe "valid factory" do
    it { is_expected.to have_a_valid_factory(:admin) }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "included modules" do
    it { is_expected.to include_module(CaseSensitivity) }
    it { is_expected.to include_module(StripAttribute) }
    it { is_expected.to include_module(DowncaseAttribute) }
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Sortable) }
    it { is_expected.to include_module(ReferenceCode) }
    it { is_expected.to include_module(Toggleable) }
  end

  describe "model configuration" do
    it { is_expected.to strip_attribute(:email) }
    it { is_expected.to downcase_attribute(:email) }
  end

  describe "constants" do
    it { is_expected.to have_constant(:THROTTLE_RESET_PERIOD) }
    it { is_expected.to have_constant(:DEFAULT_PASSWORD_EXPIRY_PERIOD) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:reference_code).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:mobile_number).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:sign_in_count).of_type(:integer).with_options(default: 0) }
    it { is_expected.to have_db_column(:current_sign_in_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:string) }
    it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:string) }
    it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }
    it { is_expected.to have_db_column(:confirmed_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:confirmation_sent_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:unconfirmed_email).of_type(:string) }
    it { is_expected.to have_db_column(:failed_attempts).of_type(:integer).with_options(default: 0) }
    it { is_expected.to have_db_column(:unlock_token).of_type(:string) }
    it { is_expected.to have_db_column(:locked_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_password_updated_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:role_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:store_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:password_automatically_set).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:password_expires_at).of_type(:timestamptz) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:is_banned).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:confirmation_token).unique(true) }
    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:mobile_number).unique(true) }
    it { is_expected.to have_db_index(:reset_password_token).unique(true) }
    it { is_expected.to have_db_index(:role_id) }
    it { is_expected.to have_db_index(:store_id) }
    it { is_expected.to have_db_index(:unlock_token).unique(true) }
    it { is_expected.to have_db_index(:reference_code).unique(true) }
    it { is_expected.to have_db_index(:is_active) }
    it { is_expected.to have_db_index(:is_banned) }

    it { is_expected.to have_foreign_key(:role_id).with_name(:fk_users_role_id_on_roles).on_delete(:restrict) }
    it { is_expected.to have_foreign_key(:store_id).with_name(:fk_users_store_id_on_stores).on_delete(:cascade) }

    it { is_expected.to have_check_constraint("chk_c231bcb127").with_condition("char_length(first_name::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_2123b67efb").with_condition("char_length(last_name::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_9a467af0b9").with_condition("char_length(mobile_number::text) <= 32") }
    it { is_expected.to have_check_constraint("chk_004c265d57").with_condition("email IS NOT NULL AND email::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_e1cfcf7283").with_condition("encrypted_password IS NOT NULL AND encrypted_password::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_973db23f5c").with_condition("failed_attempts IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_1e55406a3e").with_condition("first_name IS NOT NULL AND first_name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_a86d1f69fa").with_condition("last_name IS NOT NULL AND last_name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_b6b6a77b49").with_condition("role_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_fc2e3b8e41").with_condition("sign_in_count IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_85a5cd5c77").with_condition("char_length(reference_code::text) <= 15") }
    it { is_expected.to have_check_constraint("chk_9703a0fab3").with_condition("reference_code IS NOT NULL AND reference_code::text <> ''::text") }
  end

  describe "default values" do
    it "should set false as default value for #is_banned" do
      expect(user.is_banned).to be_falsy
    end

    it "should set false as default value for #is_active" do
      expect(user.is_active).to be_falsy
    end

    it "should set false as default value for #password_automatically_set" do
      expect(user.password_automatically_set).to be_falsy
    end
  end

  describe "associations" do
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many(:request_logs).dependent(:nullify) }
    it { is_expected.to have_many(:cash_counter_operators).dependent(:destroy) }
    it { is_expected.to have_many(:cash_counters).through(:cash_counter_operators) }
    it { is_expected.to have_many(:working_stores).through(:cash_counters).source(:store) }
    it { is_expected.to have_many(:purchase_orders).dependent(:nullify) }
    it { is_expected.to have_many(:expenses).dependent(:nullify) }
    it { is_expected.to have_many(:medicines).dependent(:nullify) }
    it { is_expected.to belong_to(:role) }
    it { is_expected.to belong_to(:store).optional }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:name).to(:store).with_prefix(true).allow_nil }
    it { is_expected.to delegate_method(:name).to(:role).with_prefix(true) }
    it { is_expected.to delegate_method(:country).to(:address) }
    it { is_expected.to delegate_method(:name).to(:country).with_prefix(true) }
  end

  describe "callbacks" do
    it { is_expected.to have_callback(:before, :create, :set_reference_code) }
    it { is_expected.to have_callback(:after, :commit, :send_active_users_count) }
  end

  include_examples "apply default scope on reference code asc"

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:address).update_only(true) }
  end

  describe "validations" do
    describe "#reference_code" do
      it { is_expected.to validate_length_of(:reference_code).is_at_most(15).with_message("is too long (maximum is 15 characters)") }
    end

    describe "#login" do
      context "when login is required" do
        before { allow(subject).to receive(:login_required?).and_return(true) }

        it { is_expected.to validate_presence_of(:login) }
      end

      context "when login is not required" do
        before { allow(subject).to receive(:login_required?).and_return(false) }

        it { is_expected.not_to validate_presence_of(:login) }
      end
    end

    describe "#password" do
      context "when password is required" do
        before { allow(subject).to receive(:password_required?).and_return(true) }

        it { is_expected.to validate_presence_of(:password) }
        it { is_expected.to validate_length_of(:password).is_at_least(8).with_message("is too short (minimum is 8 characters)") }
        it { is_expected.to validate_length_of(:password).is_at_most(15).with_message("is too long (maximum is 15 characters)") }
        it { is_expected.to validate_confirmation_of(:password) }
      end

      context "when password is not required" do
        before { allow(subject).to receive(:password_required?).and_return(false) }

        it { is_expected.not_to validate_presence_of(:password) }
        it { is_expected.not_to validate_confirmation_of(:password) }
      end
    end

    describe "#password_confirmation" do
      context "when password is present" do
        before { allow(subject).to receive(:password_present?).and_return(true) }

        it { is_expected.to validate_presence_of(:password_confirmation) }
      end

      context "when password is not present" do
        before { allow(subject).to receive(:password_present?).and_return(false) }

        it { is_expected.not_to validate_presence_of(:password_confirmation) }
      end
    end
  end

  describe "scopes" do
    let(:admin) { create(:admin, :confirmed, :active) }
    let(:manager) { create(:manager, :confirmed, :active) }
    let(:cashier) { create(:cashier, :confirmed, :active) }

    describe ".with_role" do
      it "returns array of users having given role" do
        expect(cashier).to be_one_of(described_class.with_role("cashier"))
      end
    end

    describe ".admins" do
      it "returns array of admins" do
        expect(admin).to be_one_of(described_class.admins)
      end
    end

    describe ".managers" do
      it "returns array of managers" do
        expect(manager).to be_one_of(described_class.managers)
      end
    end

    describe ".cashiers" do
      it "returns array of cashiers" do
        expect(cashier).to be_one_of(described_class.cashiers)
      end
    end
  end

  describe "class methods" do
    describe ".select_options" do
      it "should return array of users for select list" do
        user = create(:manager, :confirmed, :active)
        expect(described_class.select_options).to eq([[user.full_name, user.id]])
      end
    end
  end

  describe "instance methods" do
    describe "#admin?" do
      it "returns true" do
        expect(user.admin?).to be_truthy
      end
    end

    describe "#manager?" do
      it "returns true" do
        manager = create(:manager, :confirmed)
        expect(manager.manager?).to be_truthy
      end
    end

    describe "#cashier?" do
      it "returns true" do
        cashier = create(:cashier, :confirmed)
        expect(cashier.cashier?).to be_truthy
      end
    end

    describe "#full_name" do
      it "returns full name of the user" do
        expect(user.full_name).to eq("Harshal Ladhe")
      end
    end

    include_examples "has address"

    describe "#set_reference_code" do
      context "when super admin is created" do
        subject { create(:super_admin, :confirmed) }

        it "sets reference_code for user" do
          expect(subject.reference_code).to be_present
          expect(subject.reference_code).to eq("SA-000000000001")
        end
      end

      context "when admin is created" do
        subject { create(:admin, :confirmed) }

        it "sets reference_code for user" do
          expect(subject.reference_code).to be_present
          expect(subject.reference_code).to eq("ADM-00000000001")
        end
      end

      context "when manager is created" do
        subject { create(:manager, :confirmed) }

        it "sets reference_code for user" do
          expect(subject.reference_code).to be_present
          expect(subject.reference_code).to eq("MGR-00000000001")
        end
      end

      context "when cashier is created" do
        subject { create(:cashier, :confirmed) }

        it "sets reference_code for user" do
          expect(subject.reference_code).to be_present
          expect(subject.reference_code).to eq("CAS-00000000001")
        end
      end
    end
  end
end
