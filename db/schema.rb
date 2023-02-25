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

ActiveRecord::Schema[7.0].define(version: 2023_02_25_155751) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

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

  create_table "dosage_forms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["name"], name: "index_dosage_forms_on_name", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_ca1407d42a"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_6fb39fa26d"
  end

  create_table "ingredients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
    t.check_constraint "char_length(description) <= 1000", name: "chk_e3f3556190"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_62cbc59142"
    t.check_constraint "description IS NOT NULL AND description <> ''::text", name: "chk_f81cf0f75f"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_44ab271035"
  end

  create_table "medicine_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["name"], name: "index_medicine_categories_on_name", unique: true
    t.check_constraint "char_length(description::text) <= 255", name: "chk_563b95552d"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_03e39c141b"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_fc60a64610"
  end

  create_table "packing_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["name"], name: "index_packing_types_on_name", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_9ef2625dfe"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_c41aed63fb"
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

  create_table "stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "fax_number"
    t.boolean "is_active", default: false
    t.string "registration_number"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.boolean "is_main_store", default: false
    t.index ["email"], name: "index_stores_on_email", unique: true
    t.index ["phone_number"], name: "index_stores_on_phone_number", unique: true
    t.check_constraint "char_length(email::text) <= 55", name: "chk_0966276692"
    t.check_constraint "char_length(fax_number::text) <= 32", name: "chk_55cbeaf1bf"
    t.check_constraint "char_length(phone_number::text) <= 32", name: "chk_304d33223a"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_fc84f48d5e"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_8f1459e838"
    t.check_constraint "phone_number IS NOT NULL AND phone_number::text <> ''::text", name: "chk_2d9bb89816"
    t.check_constraint "registration_number IS NOT NULL AND registration_number::text <> ''::text", name: "chk_48a4cf1224"
  end

  create_table "suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["email"], name: "index_suppliers_on_email", unique: true
    t.index ["phone_number"], name: "index_suppliers_on_phone_number", unique: true
    t.check_constraint "char_length(email::text) <= 55", name: "chk_b1c47b4cbe"
    t.check_constraint "char_length(name::text) <= 110", name: "chk_427b1088f0"
    t.check_constraint "char_length(phone_number::text) <= 32", name: "chk_826f24ed62"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_98cae18516"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_9b9db7504e"
    t.check_constraint "phone_number IS NOT NULL AND phone_number::text <> ''::text", name: "chk_e5ebd50398"
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
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["store_id"], name: "index_users_on_store_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.check_constraint "char_length(first_name::text) <= 55", name: "chk_c231bcb127"
    t.check_constraint "char_length(last_name::text) <= 55", name: "chk_2123b67efb"
    t.check_constraint "char_length(mobile_number::text) <= 32", name: "chk_9a467af0b9"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_004c265d57"
    t.check_constraint "encrypted_password IS NOT NULL AND encrypted_password::text <> ''::text", name: "chk_e1cfcf7283"
    t.check_constraint "failed_attempts IS NOT NULL", name: "chk_973db23f5c"
    t.check_constraint "first_name IS NOT NULL AND first_name::text <> ''::text", name: "chk_1e55406a3e"
    t.check_constraint "last_name IS NOT NULL AND last_name::text <> ''::text", name: "chk_a86d1f69fa"
    t.check_constraint "role_id IS NOT NULL", name: "chk_b6b6a77b49"
    t.check_constraint "sign_in_count IS NOT NULL", name: "chk_fc2e3b8e41"
  end

  add_foreign_key "addresses", "countries", name: "fk_addresses_country_id_on_countries", on_delete: :restrict
  add_foreign_key "countries", "currencies", name: "fk_countries_currency_id_on_currencies", on_delete: :restrict
  add_foreign_key "request_logs", "users", name: "fk_request_logs_user_id_on_users", on_delete: :nullify
  add_foreign_key "users", "roles", name: "fk_users_role_id_on_roles", on_delete: :restrict
  add_foreign_key "users", "stores", name: "fk_users_store_id_on_stores", on_delete: :cascade
end
