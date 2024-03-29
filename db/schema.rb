# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_26_144517) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "expense_statuses", [["pending", "approved", "rejected"]]
  create_enum "purchase_order_statuses", [["pending", "incomplete", "received"]]
  create_enum "tax_rate_types", [["vat", "gst", "cgst", "sgst", "pst", "hst", "st"]]
  create_enum "unit_of_measures", [["kg", "g", "mg", "mcg", "l", "ml", "cc", "mol", "mmol", "ww", "qs", "wv", "lb", "f", "c", "oz", "tbsp", "tsp", "gtt", "gr", "gal", "pt", "m", "qt", "floz", "fldr", "dr", "vv"]]

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "country_id"
    t.string "addressable_type"
    t.uuid "addressable_id"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "region"
    t.string "postal_code"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.check_constraint "address1 IS NOT NULL AND address1::text <> ''::text", name: "chk_dd06263840"
    t.check_constraint "addressable_id IS NOT NULL", name: "chk_764e04cfbe"
    t.check_constraint "addressable_type IS NOT NULL", name: "chk_d04b2c3c0f"
    t.check_constraint "char_length(address1::text) <= 100", name: "chk_79a0b55f17"
    t.check_constraint "char_length(address2::text) <= 100", name: "chk_9d9af86e34"
    t.check_constraint "char_length(city::text) <= 100", name: "chk_fc9ec5eb57"
    t.check_constraint "char_length(postal_code::text) <= 20", name: "chk_39c4bcf78a"
    t.check_constraint "char_length(region::text) <= 100", name: "chk_26dd3e9819"
    t.check_constraint "city IS NOT NULL AND city::text <> ''::text", name: "chk_6c705ebe2e"
    t.check_constraint "country_id IS NOT NULL", name: "chk_f7e0314437"
  end

  create_table "cash_counter_operators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cash_counter_id"
    t.uuid "shift_id"
    t.uuid "user_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["cash_counter_id"], name: "index_cash_counter_operators_on_cash_counter_id"
    t.index ["shift_id"], name: "index_cash_counter_operators_on_shift_id"
    t.index ["user_id"], name: "index_cash_counter_operators_on_user_id"
    t.check_constraint "cash_counter_id IS NOT NULL", name: "chk_af3c28905e"
    t.check_constraint "shift_id IS NOT NULL", name: "chk_0de8100141"
    t.check_constraint "user_id IS NOT NULL", name: "chk_d9ee748c29"
  end

  create_table "cash_counters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "identifier"
    t.boolean "is_active", default: false
    t.uuid "store_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["identifier", "store_id"], name: "index_cash_counters_on_identifier_and_store_id", unique: true
    t.index ["is_active"], name: "index_cash_counters_on_is_active"
    t.index ["store_id"], name: "index_cash_counters_on_store_id"
    t.check_constraint "char_length(identifier::text) <= 55", name: "chk_536102d810"
    t.check_constraint "identifier IS NOT NULL AND identifier::text <> ''::text", name: "chk_aebf4b581d"
    t.check_constraint "store_id IS NOT NULL", name: "chk_672e9b122c"
  end

  create_table "countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "iso2"
    t.string "iso3"
    t.string "calling_code"
    t.boolean "has_postal_code", default: false
    t.boolean "is_active", default: false
    t.uuid "currency_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["currency_id"], name: "index_countries_on_currency_id"
    t.index ["is_active"], name: "index_countries_on_is_active"
    t.index ["iso2"], name: "index_countries_on_iso2", unique: true
    t.index ["iso3"], name: "index_countries_on_iso3", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
    t.check_constraint "char_length(iso2::text) = 2", name: "chk_1e56054f5a"
    t.check_constraint "char_length(iso3::text) = 3", name: "chk_291f18a38d"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_68ab57466f"
    t.check_constraint "currency_id IS NOT NULL", name: "chk_940fe1eee7"
    t.check_constraint "iso2 IS NOT NULL AND iso2::text <> ''::text", name: "chk_b1bf328063"
    t.check_constraint "iso3 IS NOT NULL AND iso3::text <> ''::text", name: "chk_87680983ee"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_03b9f57701"
    t.check_constraint "upper(iso2::text) = iso2::text", name: "chk_91b43fb014"
    t.check_constraint "upper(iso3::text) = iso3::text", name: "chk_915d162f3f"
  end

  create_table "currencies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "iso_code"
    t.string "symbol"
    t.string "subunit"
    t.integer "subunit_to_unit"
    t.boolean "symbol_first"
    t.string "decimal_mark"
    t.string "thousands_separator"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["is_active"], name: "index_currencies_on_is_active"
    t.index ["iso_code"], name: "index_currencies_on_iso_code", unique: true
    t.index ["name"], name: "index_currencies_on_name", unique: true
    t.check_constraint "char_length(decimal_mark::text) = 1", name: "chk_67f7771463"
    t.check_constraint "char_length(iso_code::text) = 3", name: "chk_61a2c44427"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_1dd815c813"
    t.check_constraint "char_length(thousands_separator::text) = 1", name: "chk_9cdc5548c1"
    t.check_constraint "decimal_mark IS NOT NULL AND decimal_mark::text <> ''::text", name: "chk_cbd3b74101"
    t.check_constraint "iso_code IS NOT NULL AND iso_code::text <> ''::text", name: "chk_b9da1bf950"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_9df5dbe3a5"
    t.check_constraint "symbol IS NOT NULL AND symbol::text <> ''::text", name: "chk_9051c710f3"
    t.check_constraint "thousands_separator IS NOT NULL AND thousands_separator::text <> ''::text", name: "chk_879dba1f31"
    t.check_constraint "upper(iso_code::text) = iso_code::text", name: "chk_63e9b93f93"
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference_code"
    t.string "name"
    t.string "email"
    t.string "mobile_number"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["is_active"], name: "index_customers_on_is_active"
    t.index ["mobile_number"], name: "index_customers_on_mobile_number", unique: true
    t.index ["reference_code"], name: "index_customers_on_reference_code", unique: true
    t.check_constraint "char_length(email::text) <= 55", name: "chk_9b044dc5bd"
    t.check_constraint "char_length(mobile_number::text) <= 32", name: "chk_3ae00196cf"
    t.check_constraint "char_length(name::text) <= 110", name: "chk_8c988d796e"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_92e8724169"
    t.check_constraint "mobile_number IS NOT NULL AND mobile_number::text <> ''::text", name: "chk_ee6ddadabe"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_7344bc8336"
    t.check_constraint "reference_code IS NOT NULL AND reference_code::text <> ''::text", name: "chk_cc9fd06e9d"
  end

  create_table "discounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "country_id"
    t.decimal "percent_off", precision: 8, scale: 2, default: "0.0"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["country_id"], name: "index_discounts_on_country_id", unique: true
    t.check_constraint "country_id IS NOT NULL", name: "chk_c97356fe73"
    t.check_constraint "percent_off >= 0.0", name: "chk_31d40f8203"
    t.check_constraint "percent_off IS NOT NULL", name: "chk_c85d23b2e0"
  end

  create_table "dosage_forms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["is_active"], name: "index_dosage_forms_on_is_active"
    t.index ["name"], name: "index_dosage_forms_on_name", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_ca1407d42a"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_6fb39fa26d"
  end

  create_table "expenses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "store_id"
    t.uuid "user_id"
    t.string "reference_code"
    t.string "criteria"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0"
    t.enum "status", default: "pending", enum_type: "expense_statuses"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["reference_code"], name: "index_expenses_on_reference_code", unique: true
    t.index ["store_id"], name: "index_expenses_on_store_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
    t.check_constraint "amount > 0.0", name: "chk_943822d0f2"
    t.check_constraint "amount IS NOT NULL", name: "chk_bf9d9a5774"
    t.check_constraint "char_length(criteria::text) <= 55", name: "chk_202a6bb4e8"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_40124d91ea"
    t.check_constraint "criteria IS NOT NULL AND criteria::text <> ''::text", name: "chk_997b885100"
    t.check_constraint "reference_code IS NOT NULL AND reference_code::text <> ''::text", name: "chk_031025e841"
    t.check_constraint "status = ANY (ARRAY['pending'::expense_statuses, 'approved'::expense_statuses, 'rejected'::expense_statuses])", name: "chk_bc1a734dee"
    t.check_constraint "store_id IS NOT NULL", name: "chk_8f7c4e83a7"
    t.check_constraint "user_id IS NOT NULL", name: "chk_e30387f221"
  end

  create_table "ingredients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference_code"
    t.string "name"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["is_active"], name: "index_ingredients_on_is_active"
    t.index ["name"], name: "index_ingredients_on_name", unique: true
    t.index ["reference_code"], name: "index_ingredients_on_reference_code", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_62cbc59142"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_a65696bd28"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_44ab271035"
    t.check_constraint "reference_code IS NOT NULL AND reference_code::text <> ''::text", name: "chk_ac4d3197c0"
  end

  create_table "manufacturers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference_code"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "customer_care_number"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["email"], name: "index_manufacturers_on_email", unique: true
    t.index ["is_active"], name: "index_manufacturers_on_is_active"
    t.index ["phone_number"], name: "index_manufacturers_on_phone_number", unique: true
    t.index ["reference_code"], name: "index_manufacturers_on_reference_code", unique: true
    t.check_constraint "char_length(email::text) <= 55", name: "chk_a17491f35f"
    t.check_constraint "char_length(name::text) <= 110", name: "chk_d3a128b5e4"
    t.check_constraint "char_length(phone_number::text) <= 32", name: "chk_1ca5089b5d"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_3ca4399acc"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_7601216330"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_64d76cfbb0"
    t.check_constraint "phone_number IS NOT NULL AND phone_number::text <> ''::text", name: "chk_8a3644299c"
    t.check_constraint "reference_code IS NOT NULL AND reference_code::text <> ''::text", name: "chk_f6b763f3b7"
  end

  create_table "medicine_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["is_active"], name: "index_medicine_categories_on_is_active"
    t.index ["name"], name: "index_medicine_categories_on_name", unique: true
    t.check_constraint "char_length(description::text) <= 255", name: "chk_563b95552d"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_03e39c141b"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_fc60a64610"
  end

  create_table "medicine_ingredients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "medicine_id"
    t.uuid "ingredient_id"
    t.boolean "active", default: false
    t.decimal "strength", precision: 8, scale: 2
    t.enum "uom", enum_type: "unit_of_measures"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["ingredient_id"], name: "index_medicine_ingredients_on_ingredient_id"
    t.index ["medicine_id"], name: "index_medicine_ingredients_on_medicine_id"
    t.check_constraint "ingredient_id IS NOT NULL", name: "chk_03d29e3ce2"
    t.check_constraint "medicine_id IS NOT NULL", name: "chk_840385d95d"
    t.check_constraint "strength IS NOT NULL", name: "chk_852f5c42d3"
    t.check_constraint "uom IS NOT NULL", name: "chk_d8241669d6"
  end

  create_table "medicine_suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "medicine_id"
    t.uuid "supplier_id"
    t.uuid "store_id"
    t.integer "total_quantity_supplied", default: 0
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["medicine_id"], name: "index_medicine_suppliers_on_medicine_id"
    t.index ["store_id"], name: "index_medicine_suppliers_on_store_id"
    t.index ["supplier_id"], name: "index_medicine_suppliers_on_supplier_id"
    t.check_constraint "medicine_id IS NOT NULL", name: "chk_fe78cbf5f6"
    t.check_constraint "store_id IS NOT NULL", name: "chk_c03bbc37c0"
    t.check_constraint "supplier_id IS NOT NULL", name: "chk_a1e7c5a927"
    t.check_constraint "total_quantity_supplied >= 0", name: "chk_fde59c4d35"
    t.check_constraint "total_quantity_supplied IS NOT NULL", name: "chk_95cd4feefd"
  end

  create_table "medicines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "medicine_category_id"
    t.uuid "dosage_form_id"
    t.uuid "packing_type_id"
    t.uuid "manufacturer_id"
    t.uuid "user_id"
    t.uuid "store_id"
    t.string "reference_code"
    t.string "name"
    t.text "description"
    t.string "batch_number"
    t.decimal "purchase_price", precision: 8, scale: 2
    t.decimal "sell_price", precision: 8, scale: 2
    t.date "manufacture_date"
    t.date "expiry_date"
    t.string "proprietary_name"
    t.decimal "strength", precision: 8, scale: 2
    t.enum "uom", enum_type: "unit_of_measures"
    t.integer "pack_size"
    t.string "therapeutic_areas"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["batch_number"], name: "index_medicines_on_batch_number"
    t.index ["dosage_form_id"], name: "index_medicines_on_dosage_form_id"
    t.index ["is_active"], name: "index_medicines_on_is_active"
    t.index ["manufacturer_id"], name: "index_medicines_on_manufacturer_id"
    t.index ["medicine_category_id"], name: "index_medicines_on_medicine_category_id"
    t.index ["packing_type_id"], name: "index_medicines_on_packing_type_id"
    t.index ["reference_code"], name: "index_medicines_on_reference_code", unique: true
    t.index ["store_id"], name: "index_medicines_on_store_id"
    t.index ["user_id"], name: "index_medicines_on_user_id"
    t.check_constraint "batch_number IS NOT NULL AND batch_number::text <> ''::text", name: "chk_977b947e5e"
    t.check_constraint "char_length(batch_number::text) <= 55", name: "chk_b952d93e37"
    t.check_constraint "char_length(description) <= 1000", name: "chk_ce3da558a4"
    t.check_constraint "char_length(name::text) <= 255", name: "chk_0e33ee0ead"
    t.check_constraint "char_length(proprietary_name::text) <= 255", name: "chk_5e9dfe5c73"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_4cf8eb74a5"
    t.check_constraint "char_length(therapeutic_areas::text) <= 255", name: "chk_46218b7add"
    t.check_constraint "dosage_form_id IS NOT NULL", name: "chk_8c1e8d17a6"
    t.check_constraint "expiry_date > CURRENT_DATE", name: "manufacture_date_gt_today"
    t.check_constraint "expiry_date IS NOT NULL", name: "chk_95781602a5"
    t.check_constraint "manufacture_date < expiry_date", name: "expiry_date_gt_manufacture_date"
    t.check_constraint "manufacture_date <= CURRENT_DATE", name: "manufacture_date_lteq_today"
    t.check_constraint "manufacture_date IS NOT NULL", name: "chk_a3d10b57f2"
    t.check_constraint "manufacturer_id IS NOT NULL", name: "chk_2b09acc801"
    t.check_constraint "medicine_category_id IS NOT NULL", name: "chk_f67d25c357"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_7db414700d"
    t.check_constraint "packing_type_id IS NOT NULL", name: "chk_78d740ce31"
    t.check_constraint "purchase_price IS NOT NULL", name: "chk_f7b18baf4f"
    t.check_constraint "reference_code IS NOT NULL AND reference_code::text <> ''::text", name: "chk_a358f560f5"
    t.check_constraint "sell_price <= purchase_price", name: "sell_price_lteq_purchase_price"
    t.check_constraint "sell_price IS NOT NULL", name: "chk_b79c9e345f"
    t.check_constraint "store_id IS NOT NULL", name: "chk_e76980da7e"
    t.check_constraint "user_id IS NOT NULL", name: "chk_b35fca260c"
  end

  create_table "packing_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["is_active"], name: "index_packing_types_on_is_active"
    t.index ["name"], name: "index_packing_types_on_name", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_9ef2625dfe"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_c41aed63fb"
  end

  create_table "purchase_order_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "purchase_order_id"
    t.uuid "medicine_id"
    t.integer "quantity", default: 1
    t.decimal "cost", precision: 8, scale: 2, default: "0.0"
    t.boolean "is_received", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["medicine_id"], name: "index_purchase_order_items_on_medicine_id"
    t.index ["purchase_order_id"], name: "index_purchase_order_items_on_purchase_order_id"
    t.check_constraint "cost > 0.0", name: "chk_0a830cb5c4"
    t.check_constraint "cost IS NOT NULL", name: "chk_06a99090c9"
    t.check_constraint "medicine_id IS NOT NULL", name: "chk_ea4129c2f2"
    t.check_constraint "purchase_order_id IS NOT NULL", name: "chk_55b2deaca4"
    t.check_constraint "quantity > 0", name: "chk_eb40210a9b"
    t.check_constraint "quantity IS NOT NULL", name: "chk_928e1be5a0"
  end

  create_table "purchase_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference_code"
    t.string "invoice_number"
    t.string "tracking_number"
    t.date "ordered_at"
    t.date "expected_arrival_at"
    t.enum "status", default: "pending", enum_type: "purchase_order_statuses"
    t.uuid "user_id"
    t.uuid "supplier_id"
    t.uuid "store_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["invoice_number"], name: "index_purchase_orders_on_invoice_number", unique: true
    t.index ["reference_code"], name: "index_purchase_orders_on_reference_code", unique: true
    t.index ["store_id"], name: "index_purchase_orders_on_store_id"
    t.index ["supplier_id"], name: "index_purchase_orders_on_supplier_id"
    t.index ["user_id"], name: "index_purchase_orders_on_user_id"
    t.check_constraint "char_length(invoice_number::text) <= 55", name: "chk_041828c53c"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_c7443cb7a7"
    t.check_constraint "char_length(tracking_number::text) <= 55", name: "chk_aad822138e"
    t.check_constraint "expected_arrival_at >= CURRENT_DATE", name: "expected_arrival_at_gteq_today"
    t.check_constraint "invoice_number IS NOT NULL AND invoice_number::text <> ''::text", name: "chk_5b2da2aebf"
    t.check_constraint "ordered_at <= CURRENT_DATE", name: "ordered_at_lteq_today"
    t.check_constraint "ordered_at IS NOT NULL", name: "chk_318f1e46ee"
    t.check_constraint "status = ANY (ARRAY['pending'::purchase_order_statuses, 'incomplete'::purchase_order_statuses, 'received'::purchase_order_statuses])", name: "chk_ecf43476d8"
    t.check_constraint "store_id IS NOT NULL", name: "chk_93de0a3636"
    t.check_constraint "supplier_id IS NOT NULL", name: "chk_a46ced21e2"
    t.check_constraint "user_id IS NOT NULL", name: "chk_e183262ac0"
  end

  create_table "replenishments", primary_key: "medicine_id", id: :uuid, default: nil, force: :cascade do |t|
    t.integer "quantity_pending_from_supplier", default: 0
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["medicine_id"], name: "index_replenishments_on_medicine_id", unique: true
    t.check_constraint "medicine_id IS NOT NULL", name: "chk_eeaeac5535"
    t.check_constraint "quantity_pending_from_supplier >= 0", name: "chk_13a13af222"
    t.check_constraint "quantity_pending_from_supplier IS NOT NULL", name: "chk_037df1962d"
  end

  create_table "request_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "uuid"
    t.string "uri"
    t.string "method"
    t.string "session_id", default: ""
    t.string "session_private_id", default: ""
    t.inet "remote_address"
    t.boolean "is_xhr", default: false
    t.jsonb "ip_info", default: "{}"
    t.uuid "user_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["ip_info"], name: "index_request_logs_on_ip_info", using: :gin
    t.index ["remote_address"], name: "index_request_logs_on_remote_address"
    t.index ["session_id"], name: "index_request_logs_on_session_id"
    t.index ["user_id"], name: "index_request_logs_on_user_id"
    t.index ["uuid"], name: "index_request_logs_on_uuid"
    t.check_constraint "ip_info IS NOT NULL", name: "chk_a67eeb00f0"
    t.check_constraint "method IS NOT NULL AND method::text <> ''::text", name: "chk_38d4d060e5"
    t.check_constraint "remote_address IS NOT NULL", name: "chk_67128961e9"
    t.check_constraint "session_id IS NOT NULL AND session_id::text <> ''::text", name: "chk_568158d334"
    t.check_constraint "session_private_id IS NOT NULL AND session_private_id::text <> ''::text", name: "chk_cb186ad202"
    t.check_constraint "uri IS NOT NULL AND uri::text <> ''::text", name: "chk_562eebdf81"
    t.check_constraint "uuid IS NOT NULL AND uuid::text <> ''::text", name: "chk_a48d3e7955"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_859b734ae2"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_ac03779a47"
  end

  create_table "shifts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.time "starts_at"
    t.time "ends_at"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["is_active"], name: "index_shifts_on_is_active"
    t.index ["name"], name: "index_shifts_on_name", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_c38ecfad43"
    t.check_constraint "ends_at IS NOT NULL", name: "chk_add794a2d1"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_00e6dffac3"
    t.check_constraint "starts_at IS NOT NULL", name: "chk_d5f2a6867c"
  end

  create_table "stocks", primary_key: "medicine_id", id: :uuid, default: nil, force: :cascade do |t|
    t.integer "quantity_in_hand", default: 0
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["medicine_id"], name: "index_stocks_on_medicine_id", unique: true
    t.check_constraint "medicine_id IS NOT NULL", name: "chk_960d9a9b0b"
    t.check_constraint "quantity_in_hand >= 0", name: "chk_f5833a0a29"
    t.check_constraint "quantity_in_hand IS NOT NULL", name: "chk_07ed382b70"
  end

  create_table "stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference_code"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "fax_number"
    t.boolean "is_active", default: false
    t.string "registration_number"
    t.uuid "currency_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["currency_id"], name: "index_stores_on_currency_id"
    t.index ["email"], name: "index_stores_on_email", unique: true
    t.index ["is_active"], name: "index_stores_on_is_active"
    t.index ["phone_number"], name: "index_stores_on_phone_number", unique: true
    t.index ["reference_code"], name: "index_stores_on_reference_code", unique: true
    t.index ["registration_number"], name: "index_stores_on_registration_number", unique: true
    t.check_constraint "char_length(email::text) <= 55", name: "chk_0966276692"
    t.check_constraint "char_length(fax_number::text) <= 32", name: "chk_55cbeaf1bf"
    t.check_constraint "char_length(phone_number::text) <= 32", name: "chk_304d33223a"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_42f8a2c319"
    t.check_constraint "currency_id IS NOT NULL", name: "chk_3186c58582"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_fc84f48d5e"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_8f1459e838"
    t.check_constraint "phone_number IS NOT NULL AND phone_number::text <> ''::text", name: "chk_2d9bb89816"
    t.check_constraint "reference_code IS NOT NULL AND reference_code::text <> ''::text", name: "chk_83a023b8df"
    t.check_constraint "registration_number IS NOT NULL AND registration_number::text <> ''::text", name: "chk_48a4cf1224"
  end

  create_table "suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference_code"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["email"], name: "index_suppliers_on_email", unique: true
    t.index ["is_active"], name: "index_suppliers_on_is_active"
    t.index ["phone_number"], name: "index_suppliers_on_phone_number", unique: true
    t.index ["reference_code"], name: "index_suppliers_on_reference_code", unique: true
    t.check_constraint "char_length(email::text) <= 55", name: "chk_b1c47b4cbe"
    t.check_constraint "char_length(name::text) <= 110", name: "chk_427b1088f0"
    t.check_constraint "char_length(phone_number::text) <= 32", name: "chk_826f24ed62"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_0996151ba1"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_98cae18516"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_9b9db7504e"
    t.check_constraint "phone_number IS NOT NULL AND phone_number::text <> ''::text", name: "chk_e5ebd50398"
    t.check_constraint "reference_code IS NOT NULL AND reference_code::text <> ''::text", name: "chk_bda7229b58"
  end

  create_table "tax_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "country_id"
    t.decimal "rate", precision: 8, scale: 2, default: "0.0"
    t.enum "type", default: "gst", enum_type: "tax_rate_types"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["country_id"], name: "index_tax_rates_on_country_id", unique: true
    t.check_constraint "country_id IS NOT NULL", name: "chk_dcb54ba6b7"
    t.check_constraint "rate >= 0.0", name: "chk_321df07473"
    t.check_constraint "rate IS NOT NULL", name: "chk_a7c583dbd4"
    t.check_constraint "type IS NOT NULL", name: "chk_d92ff7e269"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "mobile_number"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.timestamptz "reset_password_sent_at"
    t.timestamptz "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.timestamptz "current_sign_in_at"
    t.timestamptz "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.timestamptz "confirmed_at"
    t.timestamptz "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.timestamptz "locked_at"
    t.string "reference_code"
    t.string "first_name"
    t.string "last_name"
    t.timestamptz "last_password_updated_at"
    t.uuid "role_id"
    t.boolean "password_automatically_set", default: false
    t.timestamptz "password_expires_at"
    t.boolean "is_active", default: false
    t.boolean "is_banned", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.uuid "store_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["is_banned"], name: "index_users_on_is_banned"
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
    t.index ["reference_code"], name: "index_users_on_reference_code", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["store_id"], name: "index_users_on_store_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.check_constraint "char_length(first_name::text) <= 55", name: "chk_c231bcb127"
    t.check_constraint "char_length(last_name::text) <= 55", name: "chk_2123b67efb"
    t.check_constraint "char_length(mobile_number::text) <= 32", name: "chk_9a467af0b9"
    t.check_constraint "char_length(reference_code::text) <= 15", name: "chk_85a5cd5c77"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_004c265d57"
    t.check_constraint "encrypted_password IS NOT NULL AND encrypted_password::text <> ''::text", name: "chk_e1cfcf7283"
    t.check_constraint "failed_attempts IS NOT NULL", name: "chk_973db23f5c"
    t.check_constraint "first_name IS NOT NULL AND first_name::text <> ''::text", name: "chk_1e55406a3e"
    t.check_constraint "last_name IS NOT NULL AND last_name::text <> ''::text", name: "chk_a86d1f69fa"
    t.check_constraint "reference_code IS NOT NULL AND reference_code::text <> ''::text", name: "chk_9703a0fab3"
    t.check_constraint "role_id IS NOT NULL", name: "chk_b6b6a77b49"
    t.check_constraint "sign_in_count IS NOT NULL", name: "chk_fc2e3b8e41"
  end

  add_foreign_key "addresses", "countries", name: "fk_addresses_country_id_on_countries", on_delete: :restrict
  add_foreign_key "cash_counter_operators", "cash_counters", name: "fk_cash_counter_operators_cash_counter_id_on_cash_counters", on_delete: :cascade
  add_foreign_key "cash_counter_operators", "shifts", name: "fk_cash_counter_operators_shift_id_on_shifts", on_delete: :restrict
  add_foreign_key "cash_counter_operators", "users", name: "fk_cash_counter_operators_user_id_on_users", on_delete: :restrict
  add_foreign_key "cash_counters", "stores", name: "fk_cash_counters_store_id_on_stores", on_delete: :cascade
  add_foreign_key "countries", "currencies", name: "fk_countries_currency_id_on_currencies", on_delete: :restrict
  add_foreign_key "discounts", "countries", name: "fk_discounts_country_id_on_countries", on_delete: :restrict
  add_foreign_key "expenses", "stores", name: "fk_expenses_store_id_on_stores", on_delete: :cascade
  add_foreign_key "expenses", "users", name: "fk_expenses_user_id_on_users", on_delete: :nullify
  add_foreign_key "medicine_ingredients", "ingredients", name: "fk_medicine_ingredients_ingredient_id_on_ingredients", on_delete: :restrict
  add_foreign_key "medicine_ingredients", "medicines", name: "fk_medicine_ingredients_medicine_id_on_medicines", on_delete: :cascade
  add_foreign_key "medicine_suppliers", "medicines", name: "fk_medicine_suppliers_medicine_id_on_medicines", on_delete: :cascade
  add_foreign_key "medicine_suppliers", "stores", name: "fk_medicine_suppliers_store_id_on_stores", on_delete: :cascade
  add_foreign_key "medicine_suppliers", "suppliers", name: "fk_medicine_suppliers_supplier_id_on_suppliers", on_delete: :restrict
  add_foreign_key "medicines", "dosage_forms", name: "fk_medicines_dosage_form_id_on_dosage_forms", on_delete: :restrict
  add_foreign_key "medicines", "manufacturers", name: "fk_medicines_manufacturer_id_on_manufacturers", on_delete: :restrict
  add_foreign_key "medicines", "medicine_categories", name: "fk_medicines_medicine_category_id_on_medicine_categories", on_delete: :restrict
  add_foreign_key "medicines", "packing_types", name: "fk_medicines_packing_type_id_on_packing_types", on_delete: :restrict
  add_foreign_key "medicines", "stores", name: "fk_medicines_store_id_on_stores", on_delete: :cascade
  add_foreign_key "medicines", "users", name: "fk_medicines_user_id_on_users", on_delete: :nullify
  add_foreign_key "purchase_order_items", "medicines", name: "fk_purchase_order_items_medicine_id_on_medicines", on_delete: :cascade
  add_foreign_key "purchase_order_items", "purchase_orders", name: "fk_purchase_order_items_purchase_order_id_on_purchase_orders", on_delete: :cascade
  add_foreign_key "purchase_orders", "stores", name: "fk_purchase_orders_store_id_on_stores", on_delete: :restrict
  add_foreign_key "purchase_orders", "suppliers", name: "fk_purchase_orders_supplier_id_on_suppliers", on_delete: :restrict
  add_foreign_key "purchase_orders", "users", name: "fk_purchase_orders_user_id_on_users", on_delete: :nullify
  add_foreign_key "replenishments", "medicines", name: "fk_replenishments_medicine_id_on_medicines", on_delete: :cascade
  add_foreign_key "request_logs", "users", name: "fk_request_logs_user_id_on_users", on_delete: :nullify
  add_foreign_key "stocks", "medicines", name: "fk_stocks_medicine_id_on_medicines", on_delete: :cascade
  add_foreign_key "stores", "currencies", name: "fk_stores_currency_id_on_currencies", on_delete: :restrict
  add_foreign_key "tax_rates", "countries", name: "fk_tax_rates_country_id_on_countries", on_delete: :restrict
  add_foreign_key "users", "roles", name: "fk_users_role_id_on_roles", on_delete: :restrict
  add_foreign_key "users", "stores", name: "fk_users_store_id_on_stores", on_delete: :cascade
end
