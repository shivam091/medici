# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateRequestLogs < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :request_logs, id: :uuid do |t|
      t.string :uuid, index: {using: :btree}
      t.string :uri
      t.string :method
      t.string :session_id, index: {using: :btree}
      t.string :session_private_id
      t.inet :remote_address, index: {using: :btree}
      t.boolean :is_xhr, default: false
      t.jsonb :ip_info, default: "{}", index: {using: :gin}
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_request_logs_user_id_on_users,
                     on_delete: :nullify
                   },
                   null: true,
                   index: {using: :btree}
      t.not_null_and_empty_constraint :uuid
      t.not_null_and_empty_constraint :uri
      t.not_null_and_empty_constraint :method
      t.not_null_and_empty_constraint :session_id
      t.not_null_and_empty_constraint :session_private_id

      t.not_null_constraint :remote_address
      t.not_null_constraint :ip_info

      t.timestamps_with_timezone null: false
    end
  end
end
