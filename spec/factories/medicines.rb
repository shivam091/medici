# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :medicine do
    name { "Fluticasone Furoate Aqueous Nasal Spray" }
    proprietary_name { "Fluticone-FT" }
    description { "Fluticasone is used to treat seasonal and year-round allergy symptoms such as stuffy/runny nose, itching, and sneezing." }
    batch_number { "AFY1154" }
    purchase_price { 467.00 }
    sell_price { 455.23 }
    manufacture_date { Date.current }
    expiry_date { (Date.current + 1.year) }
    strength { 27.5 }
    uom { "mcg" }
    therapeutic_areas { "used to treat allergic symptoms" }
    pack_size { 1 }
    medicine_category { ::MedicineCategory.first || create(:medicine_category, :active) }
    dosage_form { ::DosageForm.first || create(:dosage_form, :active) }
    packing_type { ::PackingType.first || create(:packing_type, :active) }
    manufacturer { ::Manufacturer.first || create(:manufacturer, :with_address, :active) }
    store { ::Store.first || create(:store, :with_address, :active) }

    trait :with_suppliers do
      after(:create) do |medicine, evaluator|
        create(:medicine_supplier, medicine: medicine)
      end
    end

    trait :with_ingredients do
      after(:create) do |medicine, evaluator|
        create(:medicine_ingredient, medicine: medicine)
      end
    end
  end
end
