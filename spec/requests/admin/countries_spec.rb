# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/requests/admin/countries_spec.rb

require "spec_helper"

RSpec.describe "Admin::Countries", type: :request do
  let!(:country) { create(:country, :active) }
  let!(:currency) { create(:currency, :active, name: "United states", iso_code: "USD") }
  let!(:inactive_country) { create(:country, name: "Inactive country", iso2: "AA", iso3: "AAA") }

  context "when user is not logged in" do
    describe "GET /admin/countries" do
      subject { get admin_countries_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/countries/active" do
      subject { get active_admin_countries_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/countries/inactive" do
      subject { get inactive_admin_countries_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/countries/new" do
      subject { get new_admin_country_path }

      it { is_expected.to require_login }
    end

    describe "POST /admin/countries" do
      subject { post admin_countries_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/countries/:uuid/edit" do
      subject { get edit_admin_country_path(country) }

      it { is_expected.to require_login }
    end

    describe "PUT|PATCH /admin/countries/:uuid" do
      subject { put admin_country_path(country) }

      it { is_expected.to require_login }
    end

    describe "PATCH /admin/countries/:uuid/activate" do
      subject { patch activate_admin_country_path(country) }

      it { is_expected.to require_login }
    end

    describe "PATCH /admin/countries/:uuid/deactivate" do
      subject { patch deactivate_admin_country_path(country) }

      it { is_expected.to require_login }
    end

    describe "DELETE /admin/countries/:uuid" do
      subject { delete admin_country_path(country) }

      it { is_expected.to require_login }
    end
  end

  context "when user is logged in" do
    include_context "login as admin"

    describe "GET /admin/countries" do
      before { get admin_countries_path }

      it "assigns @countries" do
        expect(ivar(:countries).reload).to include(country)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/countries/active" do
      before { get active_admin_countries_path }

      it "checks if all countries are active" do
        expect(ivar(:countries)).to all(be_active)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/countries/inactive" do
      before { get inactive_admin_countries_path }

      it "checks if all countries are inactive" do
        expect(ivar(:countries)).to all(be_inactive)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/countries/new" do
      before { get new_admin_country_path }

      include_examples "initializes a new instance", :country, ::Country

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/countries" do
      context "with valid attributes" do
        subject do
          post admin_countries_path, params: {
            country: attributes_for(
              :country,
              name: "United States", iso2: "US", iso3: "USA", currency_id: currency.id)
          }, as: :turbo_stream
        end

        include_examples "creates a new object", ::Country

        it "returns :found status" do
          post admin_countries_path, params: {
            country: attributes_for(
              :country,
              name: "United States", iso2: "US", iso3: "USA", currency_id: currency.id)
          }, as: :turbo_stream

          expect(response).to have_http_status(:found)
        end

        it "redirects to listing page" do
          post admin_countries_path, params: {
            country: attributes_for(
              :country,
              name: "United States", iso2: "US", iso3: "USA", currency_id: currency.id)
          }, as: :turbo_stream

          expect(response).to redirect_to(admin_countries_path)
        end

        it "sets flash message" do
          post admin_countries_path, params: {
            country: attributes_for(
              :country,
              name: "United States", iso2: "US", iso3: "USA", currency_id: currency.id)
          }, as: :turbo_stream

          ivar(:country).reload
          follow_redirect!

          expect(flash[:notice]).to eq("Country 'United States' was successfully created.")
        end
      end

      context "with invalid attributes" do
        include_examples "does not change count of objects", ::Country

        it "renders turbo stream to update turbo frame 'country_form'" do
          post admin_countries_path, params: {
            country: attributes_for(:country, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"country_form\">")
        end

        it "sets flash message" do
          post admin_countries_path, params: {
            country: attributes_for(:country, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Country could not be created.")
        end
      end
    end

    describe "GET /admin/countries/:uuid/edit" do
      before { get edit_admin_country_path(country) }

      it "assigns a country to @country" do
        expect(ivar(:country)).to eq(country)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PUT/PATCH /admin/countries/:uuid" do
      context "with valid attributes" do
        before do
          put admin_country_path(country), params: {
            country: attributes_for(:country, name: "Australia")
          }, as: :turbo_stream
        end

        it "locates the requested @country" do
          expect(ivar(:country)).to eq(country)
        end

        it "updates the country" do
          country = ivar(:country).reload
          expect(country.name).to eq("Australia")
        end

        it "redirects to listing page" do
          expect(response).to redirect_to(admin_countries_path)
        end

        it "sets flash message" do
          expect(flash[:notice]).to eq("Country 'Australia' was successfully updated.")
        end
      end

      context "with invalid attributes" do
        before do
          put admin_country_path(country), params: {
            country: attributes_for(:country, name: "")
          }, as: :turbo_stream
        end

        it "does not update the country" do
          ivar(:country).reload
          expect(country.name).to eq("India")
        end

        it "renders turbo stream to update turbo frame 'country_form'" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"country_form\">")
        end

        it "sets flash message" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Country could not be updated.")
        end
      end
    end

    describe "DELETE /admin/countries/:uuid" do
      subject { delete admin_country_path(country) }

      context "with valid 'uuid'" do
        it "locates the requested @country" do
          delete admin_country_path(country)
          expect(ivar(:country)).to eq(country)
        end

        include_examples "deletes an object", ::Country

        it "redirects to listing page and sets flash message" do
          delete admin_country_path(country)
          expect(response).to redirect_to(admin_countries_path)
        end

        it "sets flash message" do
          delete admin_country_path(country)
          expect(flash[:info]).to eq("Country 'India' was successfully destroyed.")
        end
      end

      context "with invalid 'uuid'" do
        before do
          allow(::Countries::DestroyService).to receive(:call).and_return(
            ServiceResponse.error(message: "Country 'India' could not be destroyed.")
          )
        end

        include_examples "does not change count of objects", ::Country
      end
    end

    describe "PATCH /admin/countries/:uuid/activate" do
      context "when the activation is successful" do
        before do
          patch activate_admin_country_path(inactive_country)
        end

        it "activates the country" do
          expect(inactive_country.reload.is_active?).to be_truthy
        end

        it "sets a success flash message" do
          expect(flash[:notice]).to eq("Country 'Inactive country' was successfully activated.")
        end

        it "redirects to inactive countries page" do
          expect(response).to redirect_to(inactive_admin_countries_path)
        end
      end

      context "when the activation fails" do
        before do
          allow(::Countries::ActivateService).to receive(:call).and_return(
            ServiceResponse.error(message: "Country 'Inactive country' could not be activated.")
          )
          patch activate_admin_country_path(inactive_country)
        end

        it "does not activate the country" do
          expect(inactive_country.reload.is_active?).to be_falsy
        end

        it "sets an alert flash message" do
          expect(flash[:alert]).to be_present
        end

        it "redirects to inactive countries page" do
          expect(response).to redirect_to(inactive_admin_countries_path)
        end
      end
    end

    describe "PATCH /admin/countries/:uuid/deactivate" do
      context "when the deactivation is successful" do
        before do
          patch deactivate_admin_country_path(country)
        end

        it "deactivates the country" do
          expect(country.reload.is_active?).to be_falsy
        end

        it "sets a warning flash message" do
          expect(flash[:warning]).to eq("Country 'India' was successfully deactivated.")
        end

        it "redirects to countries list page" do
          expect(response).to redirect_to(admin_countries_path)
        end
      end

      context "when the deactivation fails" do
        before do
          allow(::Countries::DeactivateService).to receive(:call).and_return(
            ServiceResponse.error(message: "Country 'India' could not be deactivated.")
          )
          patch deactivate_admin_country_path(country)
        end

        it "does not deactivate the country" do
          expect(country.reload.is_active?).to be_truthy
        end

        it "sets an alert flash message" do
          expect(flash[:alert]).to be_present
        end

        it "redirects to countries list page" do
          expect(response).to redirect_to(admin_countries_path)
        end
      end
    end
  end
end
