# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateAuditTrails < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :audit_trails, id: :uuid do |t|
      t.references :auditable, type: :uuid, polymorphic: true
      t.references :associated, type: :uuid, polymorphic: true
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: "fk_audit_trails_user_id_on_users",
                     on_delete: :nullify
                   }
      t.string :action
      t.string :request_uuid, index: {using: :btree, unique: true}
      t.string :remote_ip, index: {using: :btree}
      t.jsonb :audited_changes, default: "{}", index: {using: :gin}
      t.integer :version

      t.not_null_and_empty_constraint :action
      t.not_null_and_empty_constraint :request_uuid
      t.not_null_and_empty_constraint :remote_ip

      t.inclusion_constraint :action, in: %i(create update delete)

      t.timestamptz :created_at
    end
  end
end
