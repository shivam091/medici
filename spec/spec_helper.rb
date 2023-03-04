# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "spec_helper"

ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "shoulda/matchers"
require "rspec-parameterized"

def spec_root
  Pathname.new(File.expand_path(__dir__))
end

require "./spec/simplecov_env"
SimpleCovEnv.start!

begin
  # ActiveRecord::Migration.maintain_test_schema!
  if ActiveRecord::Base.connection.migration_context.needs_migration?
    ActiveRecord::MigrationContext.new(File.join(Rails.root, "db/migrate")).migrate
  end
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.order = "default"

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation, except: %w(ar_internal_metadata)

    FileUtils.mkdir_p spec_root / "test_migrations"
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = [:expect, :should]
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Include support classes and modules.
  config.include RailsHelpers
  config.include MigrationHelpers
  config.include ViewAssigns, type: :request

  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before(:context) do
    DatabaseCleaner.start
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.after(:context) do
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    FileUtils.rm_rf spec_root / "test_migrations"
  end
end
