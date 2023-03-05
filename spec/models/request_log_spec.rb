# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/request_log_spec.rb

require "spec_helper"

RSpec.describe RequestLog, type: :model do
  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "included modules" do
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Sortable) }
    it { is_expected.to include_module(UpcaseAttribute) }
  end

  describe "module configuration" do
    it { is_expected.to upcase_attribute(:method) }
  end

  describe "included modules" do
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Sortable) }
    it { is_expected.to include_module(UpcaseAttribute) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:uuid).of_type(:string) }
    it { is_expected.to have_db_column(:uri).of_type(:string) }
    it { is_expected.to have_db_column(:method).of_type(:string) }
    it { is_expected.to have_db_column(:session_id).of_type(:string).with_options(default: "") }
    it { is_expected.to have_db_column(:session_private_id).of_type(:string).with_options(default: "") }
    it { is_expected.to have_db_column(:remote_address).of_type(:inet) }
    it { is_expected.to have_db_column(:is_xhr).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:ip_info).of_type(:jsonb).with_options(default: "{}") }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:ip_info) }
    it { is_expected.to have_db_index(:remote_address) }
    it { is_expected.to have_db_index(:session_id) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:uuid) }

    it { is_expected.to have_foreign_key(:user_id).with_name(:fk_request_logs_user_id_on_users).on_delete(:nullify) }

    it { is_expected.to have_check_constraint("chk_a67eeb00f0").with_condition("ip_info IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_38d4d060e5").with_condition("method IS NOT NULL AND method::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_67128961e9").with_condition("remote_address IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_568158d334").with_condition("session_id IS NOT NULL AND session_id::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_cb186ad202").with_condition("session_private_id IS NOT NULL AND session_private_id::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_562eebdf81").with_condition("uri IS NOT NULL AND uri::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_a48d3e7955").with_condition("uuid IS NOT NULL AND uuid::text <> ''::text") }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user).optional }
  end

  describe "default scope" do
    it "should apply default scope on #created_at" do
      expect(described_class.all.to_sql).to eq described_class.all.order(created_at: :desc).to_sql
    end
  end
end
