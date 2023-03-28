# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateUsers < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :users, id: :uuid do |t|
      ## Database authenticatable
      t.string :email, index: {using: :btree, unique: true}
      t.string :mobile_number, index: {using: :btree, unique: true}
      t.string :encrypted_password

      ## Recoverable
      t.string :reset_password_token, index: {using: :btree, unique: true}
      t.timestamptz :reset_password_sent_at

      ## Rememberable
      t.timestamptz :remember_created_at

      ## Trackable
      t.integer :sign_in_count, default: 0
      t.timestamptz :current_sign_in_at
      t.timestamptz :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Confirmable
      t.string :confirmation_token, index: {using: :btree, unique: true}
      t.timestamptz :confirmed_at
      t.timestamptz :confirmation_sent_at
      t.string :unconfirmed_email

      ## Lockable
      t.integer :failed_attempts, default: 0
      t.string :unlock_token, index: {using: :btree, unique: true}
      t.timestamptz :locked_at

      # Additional attributes
      t.string :reference_code, index: {using: :btree, unique: true}
      t.string :first_name
      t.string :last_name
      t.timestamptz :last_password_updated_at
      t.references :role,
                   type: :uuid,
                   foreign_key: {
                     to_table: :roles,
                     name: :fk_users_role_id_on_roles,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.boolean :password_automatically_set, default: false
      t.timestamptz :password_expires_at
      t.boolean :is_active, default: false, index: {using: :btree}
      t.boolean :is_banned, default: false, index: {using: :btree}

      t.timestamps_with_timezone null: false

      t.length_constraint :reference_code, less_than_or_equal_to: 15
      t.length_constraint :first_name, less_than_or_equal_to: 55
      t.length_constraint :last_name, less_than_or_equal_to: 55
      t.length_constraint :mobile_number, less_than_or_equal_to: 32

      t.not_null_constraint :sign_in_count
      t.not_null_constraint :failed_attempts
      t.not_null_constraint :role_id

      t.not_null_and_empty_constraint :reference_code
      t.not_null_and_empty_constraint :email
      t.not_null_and_empty_constraint :first_name
      t.not_null_and_empty_constraint :last_name
      t.not_null_and_empty_constraint :encrypted_password
    end
  end
end
