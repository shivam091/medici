# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/lib/medici/favicon_spec.rb

require "spec_helper"

describe ::Medici::Favicon, :request_store do
  describe ".main" do
    it "returns the URL of the favicon in development environment" do
      stub_rails_env("development")
      expect(described_class.main).to match_asset_path("/assets/favicon.ico")
    end

    it "returns the URL of the favicon in test environment" do
      stub_rails_env("test")
      expect(described_class.main).to match_asset_path("/assets/favicon.ico")
    end

    it "returns the URL of the favicon in staging environment" do
      stub_rails_env("staging")
      expect(described_class.main).to match_asset_path("/assets/favicon.ico")
    end

    it "returns the URL of the favicon in production environment" do
      stub_rails_env("production")
      expect(described_class.main).to match_asset_path("/assets/favicon.ico")
    end
  end
end
