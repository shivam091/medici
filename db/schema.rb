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

ActiveRecord::Schema[7.0].define(version: 2023_02_22_153726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
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

  add_foreign_key "request_logs", "users", name: "fk_request_logs_user_id_on_users", on_delete: :nullify
  add_foreign_key "users", "roles", name: "fk_users_role_id_on_roles", on_delete: :restrict
end
