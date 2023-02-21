# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module MigrationHelpers
  def self.included(klass)
    klass.extend ClassMethods
  end

  def migration_filename(class_name, version)
    "%03d_#{class_name.to_s.underscore}.rb" % version
  end

  def migration_path
    spec_root / "test_migrations"
  end

  def connection
    ActiveRecord::Base.connection
  end

  def execute(sql)
    connection.execute(sql)
  end

  def migration_context
    klass = ActiveRecord::MigrationContext

    case klass.instance_method(:initialize).arity
    when 1
      klass.new(migration_path)
    else
      klass.new(migration_path, schema_migration)
    end
  end

  def schema_migration
    if connection.respond_to?(:schema_migration)
      connection.schema_migration
    else
      ActiveRecord::SchemaMigration
    end
  end

  # The base class for migrations moves around a lot
  def migration_class
    "Medici::Database::Migration[1.0]"
  end

  module ClassMethods
    def with_migration(class_name, version, body)
      if public_instance_methods.include?("migration_#{version}".to_sym)
        raise ArgumentError, "Migration version #{version} already defined!"
      end

      indented_body = body.to_s.strip_heredoc
      indented_body = indented_body.each_line.map { |str| str.prepend("  ") }.join

      let("migration_#{version}") { migration_path / migration_filename(class_name, version) }

      before do
        full_pathname = send("migration_#{version}")

        File.open(full_pathname, "w+") do |migration|
        migration.write(<<-EOF)
          class #{class_name} < #{migration_class}
            #{indented_body}
          end
        EOF
        end
      end

      after { File.delete send("migration_#{version}") }
    end
  end
end
