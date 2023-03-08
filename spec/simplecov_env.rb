# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "simplecov"

module SimpleCovEnv
  extend self

  def start!
    configure_profile
    configure_formatter
    configure_filters
    write_coverage_percentage

    SimpleCov.start
  end

  private

  def configure_formatter
    SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::SimpleFormatter,
        SimpleCov::Formatter::HTMLFormatter,
      ]
    )
  end

  def write_coverage_percentage
    SimpleCov.at_exit do
      File.open(File.join(SimpleCov.coverage_path, "coverage_percent.txt"), "w") do |f|
        f.write SimpleCov.result.covered_percent
      end
      SimpleCov.result.format!
    end
  end

  def configure_filters
    SimpleCov.configure do
      add_filter "spec"
    end
  end

  def configure_profile
    SimpleCov.configure do
      load_profile "test_frameworks"
      # track_files "{app,config/initializers,db/migrate,lib}/**/*.rb"

      add_group "Channels", "app/channels"
      add_group "Controllers", "app/controllers"
      add_group "Helpers", "app/helpers"
      add_group "Mailers", "app/mailers"
      add_group "Models", "app/models"
      add_group "Policies", "app/policies"
      add_group "Presenters", "app/presenters"
      add_group "Services", "app/services"
      add_group "Validators", "app/validators"
      add_group "Workers", %w[app/jobs app/workers]
      add_group "Initializers", "config/initializers"
      add_group "Migrations", "db/migrate"
      add_group "Libraries", "lib"

      add_group "Long files" do |src_file|
        src_file.lines.count > 100
      end
      add_group "Short files" do |src_file|
        src_file.lines.count < 5
      end

      merge_timeout 365 * 24 * 3600
    end
  end
end
