# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/lib/activerecord/connection_adapters/postgresql_adapter.rb

require "spec_helper"

RSpec.describe ActiveRecord::ConnectionAdapters::PostgreSQLAdapter do
  with_migration :AddStatuses, 1, <<-EOF
    def change
      create_enum "status_type", ['active', 'archived', 'on hold']
    end
  EOF

  subject { migration_context }

  context "create_enum" do
    before do
      ActiveRecord::SchemaMigration.drop_table
      execute "DROP TYPE IF EXISTS status_type"
    end

    after do
      ActiveRecord::SchemaMigration.drop_table
      execute "DROP TYPE IF EXISTS status_type"
    end

    it "creates a new enum" do
      expect(subject.current_version).to eq 0
      expect { subject.up(1) }.to_not raise_error
      expect(subject.current_version).to eq 1
      expect(connection.enum_types).to include("status_type" => ['active', 'archived', 'on hold'])
    end
  end

  context "drop_enum" do

    let (:existing_last_version) { subject.schema_migration.last.version }

    before do
      execute("DROP TYPE IF EXISTS status_type")
      execute("CREATE TYPE status_type AS ENUM ('active', 'archived')")
      ActiveRecord::SchemaMigration.tap(&:create_table).find_or_create_by(version: "1")
    end

    describe "drop the enum with no other options" do
      it "drops the enum type" do
        expect(subject.schema_migration.last.version).to eq existing_last_version
        expect { subject.down(0) }.to_not raise_error
        expect(subject.current_version).to eq existing_last_version
        expect(connection.enum_types).to_not include("status_type" => %w[active archived])
      end
    end

    describe "drop the enum with if_exists option" do
      it "drops the enum if it exists" do
        expect do
          connection.drop_enum :inexistent_enum, [], if_exists: true
        end.to_not raise_error
      end
    end
  end

  context "rename_enum" do
    with_migration :RenameStatusType, 2, <<-EOF
      def change
        rename_enum "status_type", to: "order_status_type"
      end
    EOF

    before do
      ActiveRecord::SchemaMigration.drop_table
      execute("DROP TYPE IF EXISTS status_type")
    end

    after do
      ActiveRecord::SchemaMigration.drop_table
      execute("DROP TYPE IF EXISTS status_type")
      execute("DROP TYPE IF EXISTS order_status_type")
    end

    let(:statuses) { ["active", "archived", "on hold"] }

    it "renames an existing type" do
      subject.up(1)
      subject.up(2)
      expect(connection.enum_types).to include("order_status_type" => statuses)
    end

    it "is reversible" do
      subject.up(2)
      expect { subject.down(1) }.to_not raise_error
      expect(connection.enum_types).to include("status_type")
    end

    it "will throw ArgumentError if TO cluase if not specified" do
      expect { subject.up(1) }.to_not raise_error
      expect do
        connection.rename_enum "status_type"
      end.to raise_error(ArgumentError)
    end
  end

  context "rename_enum_value" do
    with_migration :CamelizeStatuses, 2, <<-EOF
      def change
        rename_enum_value "status_type", from: "active", to: "Active"
        rename_enum_value "status_type", from: "archived", to: "Archived"
        rename_enum_value "status_type", from: "on hold", to: "OnHold"
      end
    EOF

    before do
      ActiveRecord::SchemaMigration.drop_table
      execute("DROP TYPE IF EXISTS status_type")
    end

    after do
      ActiveRecord::SchemaMigration.drop_table
      execute("DROP TYPE IF EXISTS status_type")
    end

    it "will throw ArgumentError if FROM cluase if not specified" do
      expect do
        connection.rename_enum_value "status_type", to: "Active"
      end.to raise_error(ArgumentError)
    end

    it "will throw ArgumentError if TO cluase if not specified" do
      expect do
        connection.rename_enum_value "status_type", from: "active"
      end.to raise_error(ArgumentError)
    end

    it "changes ENUM labels" do
      subject.up(1)
      expect { subject.up(2) }.to change { connection.enum_types["status_type"] }
        .from(["active", "archived", "on hold"]).to(["Active", "Archived", "OnHold"])
    end

    it "is reversible" do
      subject.up(2)
      expect { subject.down(1) }.to_not raise_error
      expect(connection.enum_types.to_h["status_type"]).to eq(["active", "archived", "on hold"])
    end
  end

  context "add_enum_value" do
    with_migration "AddEnumValue", 2, <<-EOF
      disable_ddl_transaction!
      def change
        add_enum_value "another_test_type", "baz", after: "bar"
      end
    EOF

    around(:each) do |example|
      execute "DROP TYPE IF EXISTS another_test_type"
      execute "CREATE TYPE another_test_type AS ENUM ('foo', 'bar')"
      example.run
      execute "DROP TYPE another_test_type"
    end

    def subject
      connection.enum_types["another_test_type"]
    end

    it { is_expected.to eq %w[foo bar] }

    describe "add a new type with no other options" do
      it "appends new value to the end" do
        expect do
          connection.add_enum_value "another_test_type", "baz"
        end.to_not raise_error
        expect(subject).to eq %w[foo bar baz]
      end
    end

    describe "add a new type with if_not_exists clause" do
      it "appends new value to the end if not present" do
        expect do
          connection.add_enum_value "another_test_type", "bar", if_not_exists: true
        end.to_not raise_error
        expect(subject).to eq %w[foo bar]
      end
    end

    describe "add a new type with AFTER clause" do
      it "inserts new value in the correct order" do
        expect do
          connection.add_enum_value "another_test_type", "quux", after: "foo"
        end.to_not raise_error
        expect(subject).to eq %w[foo quux bar]
      end
    end

    describe "add a new type with BEFORE clause" do
      it "inserts new value in the correct order" do
        expect do
          connection.add_enum_value "another_test_type", "quux", before: "foo"
        end.to_not raise_error
        expect(subject).to eq %w[quux foo bar]
      end
    end

    describe "add a new type with both BEFORE and AFTER" do
      it "raises an ArgumentError" do
        expect do
          connection.add_enum_value "another_test_type", "quux", before: "bar", after: "foo"
        end.to raise_error(ArgumentError)
      end
    end

    describe "migration" do
      around(:each) do |example|
        ActiveRecord::SchemaMigration.tap(&:create_table).find_or_create_by(version: "1")
        example.run
        ActiveRecord::SchemaMigration.where(version: "2").delete_all
      end

      def definition
        connection.enum_types["another_test_type"]
      end

      context ">= 5.2.0" do
        subject { migration_context }
        let (:existing_last_version) { subject.schema_migration.last.version }

        it "supports change in the forward direction" do
          subject.up(2)
          expect(definition).to eq %w[foo bar baz]
        end

        it "raises an IrreversibleMigration if rolled back" do
          execute "ALTER TYPE another_test_type ADD VALUE 'baz'"
          ActiveRecord::SchemaMigration.find_or_create_by(version: "2")

          # ActiveRecord::Migrator traps IrreversibleMigration and reraises a
          # StandardError
          expect { subject.down(1) }.to raise_error(StandardError)
        end
      end
    end
  end
end
