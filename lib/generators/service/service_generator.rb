# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ServiceGenerator < Rails::Generators::NamedBase
  desc "This generator creates a service in app/services."

  source_root File.expand_path('../templates', __FILE__)

  argument :methods, type: :array, default: []

  check_class_collision suffix: "Service"

  def create_service_file
    template "service.rb", service_path
  end

  def create_service_test_file
    case Rails.application.config.generators.rails[:test_framework]
    when :rspec
      template "rspec.rb", rspec_path
    when :test_unit
      template "test_unit.rb", test_unit_path
    when :mini_test
      if Rails.application.config.generators.mini_test[:spec]
        template "mini_test_spec.rb", mini_test_path
      else
        template "mini_test_unit.rb", mini_test_path
      end
    end
  end

  private

  def service_path
    File.join("app/services", class_path, "#{file_name}_service.rb")
  end

  def rspec_path
    File.join("spec/services", class_path, "#{file_name}_service_spec.rb")
  end

  def test_unit_path
    File.join("test/unit/services", class_path, "#{file_name}_service_test.rb")
  end

  def mini_test_path
    File.join("test/services", class_path, "#{file_name}_service_test.rb")
  end
end
