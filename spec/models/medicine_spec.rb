# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/medicine_spec.rb

require "spec_helper"

RSpec.describe Medicine, type: :model do
  describe "valid factory" do
    let(:medicine_category) { create(:medicine_category) }
    let(:manufacturer) { create(:manufacturer) }
    let(:dosage_form) { create(:dosage_form) }
    let(:packing_type) { create(:packing_type) }
    let(:user) { create(:manager) }

    it { is_expected.to have_a_valid_factory.with_associations({user:, medicine_category:, manufacturer:, dosage_form:, packing_type:}) }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "included modules" do
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Sortable) }
    it { is_expected.to include_module(ReferenceCode) }
    it { is_expected.to include_module(Toggleable) }
  end

  describe "enum" do
    ## TODO: Add specs for asserting enum exists
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:reference_code).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:medicine_category_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:dosage_form_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:packing_type_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:store_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:manufacturer_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:batch_number).of_type(:string) }
    it { is_expected.to have_db_column(:purchase_price).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { is_expected.to have_db_column(:sell_price).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { is_expected.to have_db_column(:manufacture_date).of_type(:date) }
    it { is_expected.to have_db_column(:expiry_date).of_type(:date) }
    it { is_expected.to have_db_column(:proprietary_name).of_type(:string) }
    it { is_expected.to have_db_column(:strength).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { is_expected.to have_db_column(:uom).of_type(:enum) }
    it { is_expected.to have_db_column(:pack_size).of_type(:integer) }
    it { is_expected.to have_db_column(:therapeutic_areas).of_type(:string) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:medicine_category_id) }
    it { is_expected.to have_db_index(:dosage_form_id) }
    it { is_expected.to have_db_index(:packing_type_id) }
    it { is_expected.to have_db_index(:manufacturer_id) }
    it { is_expected.to have_db_index(:store_id) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:reference_code).unique(true) }
    it { is_expected.to have_db_index(:batch_number) }
    it { is_expected.to have_db_index(:is_active) }

    it { is_expected.to have_foreign_key(:dosage_form_id).with_name(:fk_medicines_dosage_form_id_on_dosage_forms).on_delete(:restrict) }
    it { is_expected.to have_foreign_key(:manufacturer_id).with_name(:fk_medicines_manufacturer_id_on_manufacturers).on_delete(:restrict) }
    it { is_expected.to have_foreign_key(:medicine_category_id).with_name(:fk_medicines_medicine_category_id_on_medicine_categories).on_delete(:restrict) }
    it { is_expected.to have_foreign_key(:packing_type_id).with_name(:fk_medicines_packing_type_id_on_packing_types).on_delete(:restrict) }
    it { is_expected.to have_foreign_key(:store_id).with_name(:fk_medicines_store_id_on_stores).on_delete(:cascade) }
    it { is_expected.to have_foreign_key(:user_id).with_name(:fk_medicines_user_id_on_users).on_delete(:nullify) }

    it { is_expected.to have_check_constraint("chk_977b947e5e").with_condition("batch_number IS NOT NULL AND batch_number::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_b952d93e37").with_condition("char_length(batch_number::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_ce3da558a4").with_condition("char_length(description) <= 1000") }
    it { is_expected.to have_check_constraint("chk_0e33ee0ead").with_condition("char_length(name::text) <= 255") }
    it { is_expected.to have_check_constraint("chk_5e9dfe5c73").with_condition("char_length(proprietary_name::text) <= 255") }
    it { is_expected.to have_check_constraint("chk_46218b7add").with_condition("char_length(therapeutic_areas::text) <= 255") }
    it { is_expected.to have_check_constraint("manufacture_date_gt_today").with_condition("expiry_date > CURRENT_DATE") }
    it { is_expected.to have_check_constraint("chk_95781602a5").with_condition("expiry_date IS NOT NULL") }
    it { is_expected.to have_check_constraint("expiry_date_gt_manufacture_date").with_condition("manufacture_date < expiry_date") }
    it { is_expected.to have_check_constraint("manufacture_date_lteq_today").with_condition("manufacture_date <= CURRENT_DATE") }
    it { is_expected.to have_check_constraint("chk_a3d10b57f2").with_condition("manufacture_date IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_7db414700d").with_condition("name IS NOT NULL AND name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_f7b18baf4f").with_condition("purchase_price IS NOT NULL") }
    it { is_expected.to have_check_constraint("sell_price_lteq_purchase_price").with_condition("sell_price <= purchase_price") }
    it { is_expected.to have_check_constraint("chk_b79c9e345f").with_condition("sell_price IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_4cf8eb74a5").with_condition("char_length(reference_code::text) <= 15") }
    it { is_expected.to have_check_constraint("chk_a358f560f5").with_condition("reference_code IS NOT NULL AND reference_code::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_e76980da7e").with_condition("store_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_b35fca260c").with_condition("user_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_8c1e8d17a6").with_condition("dosage_form_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_2b09acc801").with_condition("manufacturer_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_f67d25c357").with_condition("medicine_category_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_78d740ce31").with_condition("packing_type_id IS NOT NULL") }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      medicine = build(:medicine)
      expect(medicine.is_active).to be_falsy
    end
  end

  describe "validations" do
    describe "#reference_code" do
      it { is_expected.to validate_length_of(:reference_code).is_at_most(15).with_message("is too long (maximum is 15 characters)") }
    end

    describe "#store_id" do
      it { is_expected.to validate_presence_of(:store_id).on(:update).with_message("is required") }
    end

    describe "#name" do
      it { is_expected.to validate_presence_of(:name).with_message("is required") }
      it { is_expected.to validate_length_of(:name).is_at_most(255).with_message("is too long (maximum is 255 characters)") }
    end

    describe "#proprietary_name" do
      it { is_expected.to validate_length_of(:proprietary_name).is_at_most(255).allow_blank.allow_nil.with_message("is too long (maximum is 255 characters)") }
    end

    describe "#description" do
      it { is_expected.to validate_length_of(:description).is_at_most(1000).allow_blank.allow_nil.with_message("is too long (maximum is 1000 characters)") }
    end

    describe "#batch_number" do
      it { is_expected.to validate_presence_of(:batch_number).with_message("is required") }
      it { is_expected.to validate_length_of(:batch_number).is_at_most(55).with_message("is too long (maximum is 55 characters)") }
    end

    describe "#therapeutic_areas" do
      it { is_expected.to validate_length_of(:therapeutic_areas).is_at_most(255).allow_blank.allow_nil.with_message("is too long (maximum is 255 characters)") }
    end

    describe "#manufacture_date" do
      it { is_expected.to validate_presence_of(:manufacture_date).with_message("is required") }
      ## TODO: Add specs for comparison validations.
    end

    describe "#expiry_date" do
      it { is_expected.to validate_presence_of(:expiry_date).with_message("is required") }
      ## TODO: Add specs for comparison validations.
    end

    describe "#purchase_price" do
      it { is_expected.to validate_presence_of(:purchase_price).with_message("is required") }
    end

    describe "#sell_price" do
      subject { build(:medicine, purchase_price: 12, sell_price: 11) }

      it { is_expected.to validate_presence_of(:sell_price).with_message("is required") }
      it { is_expected.to validate_numericality_of(:sell_price).is_less_than_or_equal_to(subject.purchase_price) }
    end

    describe "#medicine_category_id" do
      it { is_expected.to validate_presence_of(:medicine_category_id).with_message("is required") }
    end

    describe "#dosage_form_id" do
      it { is_expected.to validate_presence_of(:dosage_form_id).with_message("is required") }
    end

    describe "#user_id" do
      it { is_expected.to validate_presence_of(:user_id).with_message("is required") }
    end

    describe "#packing_type_id" do
      it { is_expected.to validate_presence_of(:packing_type_id).with_message("is required") }
    end

    describe "#manufacturer_id" do
      it { is_expected.to validate_presence_of(:manufacturer_id).with_message("is required") }
    end

    describe "#strength" do
      it { is_expected.to validate_presence_of(:strength).with_message("is required") }
      ## TODO: Add spec for greater than or equal to
      it { is_expected.to validate_numericality_of(:strength) }
    end

    describe "#uom" do
      it { is_expected.to validate_presence_of(:uom).with_message("is required") }
      it { is_expected.to validate_inclusion_of(:uom).in_array(described_class.unit_of_measurements.keys) }
    end
  end

  describe "associations" do
    it { is_expected.to have_one(:stock).dependent(:destroy) }
    it { is_expected.to have_one(:replenishment).dependent(:destroy) }
    it { is_expected.to have_many(:medicine_suppliers).dependent(:destroy) }
    it { is_expected.to have_many(:suppliers).through(:medicine_suppliers).source(:supplier).inverse_of(:medicine_suppliers) }
    it { is_expected.to have_many(:medicine_ingredients).dependent(:destroy) }
    it { is_expected.to have_many(:ingredients).through(:medicine_ingredients).source(:ingredient).inverse_of(:medicine_ingredients) }
    it { is_expected.to have_many(:purchase_order_medicines).dependent(:destroy) }
    it { is_expected.to have_many(:purchase_orders).through(:purchase_order_medicines).source(:purchase_order).inverse_of(:purchase_order_medicines) }

    it { is_expected.to belong_to(:manufacturer).inverse_of(:medicines) }
    it { is_expected.to belong_to(:medicine_category).inverse_of(:medicines) }
    it { is_expected.to belong_to(:packing_type).inverse_of(:medicines) }
    it { is_expected.to belong_to(:dosage_form).inverse_of(:medicines) }
    it { is_expected.to belong_to(:user).inverse_of(:medicines) }
    it { is_expected.to belong_to(:store).inverse_of(:medicines).optional }
  end

  describe "callbacks" do
    it { is_expected.to have_callback(:before, :create, :set_reference_code) }
    it { is_expected.to have_callback(:after, :create, :create_stock) }
    it { is_expected.to have_callback(:after, :create, :create_replenishment) }
    it { is_expected.to have_callback(:after, :commit, :broadcast_active_medicines_count) }
    it { is_expected.to have_callback(:before, :save, :set_store) }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:quantity_in_hand).to(:stock) }
    it { is_expected.to delegate_method(:quantity_pending_from_supplier).to(:replenishment) }
    it { is_expected.to delegate_method(:name).to(:manufacturer).with_prefix(true) }
    it { is_expected.to delegate_method(:email).to(:manufacturer).with_prefix(true) }
    it { is_expected.to delegate_method(:phone_number).to(:manufacturer).with_prefix(true) }
    it { is_expected.to delegate_method(:name).to(:medicine_category).with_prefix(true) }
    it { is_expected.to delegate_method(:name).to(:packing_type).with_prefix(true) }
    it { is_expected.to delegate_method(:name).to(:dosage_form).with_prefix(true) }
    it { is_expected.to delegate_method(:currency).to(:store).with_prefix(true) }
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:medicine_ingredients).allow_destroy(true) }
  end

  include_examples "apply default scope on reference code asc"

  describe "instance methods" do
    describe "#stock" do
      context "when medicine has no stock" do
        it "returns new instance of the stock" do
          expect(subject.stock).to be_a_new(::Stock)
        end
      end

      context "when medicine has a stock" do
        it "returns stock of the medicine" do
          medicine = create(:medicine, :with_user)

          expect(medicine.quantity_in_hand).to eq(0)
        end
      end
    end

    describe "#replenishment" do
      context "when medicine has no replenishment" do
        it "returns new instance of the replenishment" do
          expect(subject.replenishment).to be_a_new(::Replenishment)
        end
      end

      context "when medicine has a replenishment" do
        it "returns replenishment of the medicine" do
          medicine = create(:medicine, :with_user)

          expect(medicine.quantity_pending_from_supplier).to eq(0)
        end
      end

      describe "#set_reference_code" do
        context "when medicine is created" do
          subject { create(:medicine, :with_user) }

          it "sets reference_code for medicine" do
            expect(subject.reference_code).to be_present
            expect(subject.reference_code).to eq("MED-FL000000001")
          end
        end
      end

      describe "caching methods" do
        include_context "with cache"

        describe "#ingredients_count" do
          it "fetches count of ingredients from cache" do
            medicine = create(:medicine, :with_user, :with_ingredients, :active)
            cache_key = "medicines/#{medicine.id}/ingredients_count"

            expect(Rails.cache.exist?(cache_key)).to be_falsy
            medicine_ingredients_count = medicine.ingredients_count

            expect(Rails.cache.exist?(cache_key)).to be_truthy

            expect(medicine.ingredients_count).to eq(medicine_ingredients_count)
            expect(Rails.cache.read(cache_key)).to eq(medicine_ingredients_count)
          end
        end

        describe "#suppliers_count" do
          it "fetches count of suppliers from cache" do
            medicine = create(:medicine, :with_user, :with_suppliers, :active)
            cache_key = "medicines/#{medicine.id}/suppliers_count"

            expect(Rails.cache.exist?(cache_key)).to be_falsy
            medicine_suppliers_count = medicine.suppliers_count

            expect(Rails.cache.exist?(cache_key)).to be_truthy

            expect(medicine.suppliers_count).to eq(medicine_suppliers_count)
            expect(Rails.cache.read(cache_key)).to eq(medicine_suppliers_count)
          end
        end
      end
    end

    describe "accepts_nested_attributes_for #medicine_ingredients" do
      let(:medicine) { create(:medicine, :with_user) }
      let(:ingredient) { create(:ingredient) }

      it "allows medicine_ingredients to be created" do
        expect {
          medicine.update(medicine_ingredients_attributes: {0 => {ingredient_id: ingredient.id, strength: "500", uom: "mcg"}})
        }.to change(::MedicineIngredient, :count).by(1)
      end

      it "allows medicine_ingredients to be destroyed" do
        medicine_ingredient = create(:medicine_ingredient, medicine: medicine, ingredient: ingredient)

        expect {
          medicine.update(medicine_ingredients_attributes: {id: medicine_ingredient.id, _destroy: true})
        }.to change(::MedicineIngredient, :count).by(-1)
      end

      it "allows medicine_ingredients to be updated" do
        medicine_ingredient = create(:medicine_ingredient, medicine: medicine, ingredient: ingredient)
        expect {
          medicine.update(medicine_ingredients_attributes: {id: medicine_ingredient.id, ingredient_id: ingredient.id, strength: "500", uom: "g"})
        }.not_to change(::MedicineIngredient, :count)
        expect(medicine_ingredient.uom).to eq("g")
      end

      it "rejects medicine_ingredient attributes if they are blank" do
        expect {
          medicine.update(medicine_ingredients_attributes: {0 => {ingredient_id: "", strength: "", uom: ""}})
        }.to_not change { medicine.medicine_ingredients.count }
      end
    end
  end

  describe "class methods" do
    describe ".select_options" do
      it "should return array of medicines for select list" do
        medicine = create(:medicine, :active)
        expect(described_class.select_options).to eq([["#{medicine.name} (#{medicine.reference_code})", medicine.id]])
      end
    end
  end
end
