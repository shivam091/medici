# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require_relative "db_cleaner"

RSpec.configure do |config|
  include DbCleaner

  # Ensure the database is empty at the start of the suite run with :deletion strategy
  # neither the sequence is reset nor the tables are vacuum, but this provides
  # better I/O performance on machines with slower storage
  config.before(:suite) do
    delete_from_all_tables!
  end

  config.around(:each, :delete) do |example|
    self.class.use_transactional_tests = false

    example.run
    delete_from_all_tables!

    self.class.use_transactional_tests = true
  end
end
