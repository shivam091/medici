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
    manufacture_date { Date.today }
    expiry_date { (Date.today + 1.year) }
    strength { 27.5 }
    uom { "mcg" }
    therapeutic_areas { "used to treat allergic symptoms" }
    pack_size { 1 }
    association(:medicine_category, :active)
    association(:dosage_form, :active)
    association(:packing_type, :active)
    association(:manufacturer, :with_address, :active)

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
