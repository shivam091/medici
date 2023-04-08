# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/requests/admin/currencies_spec.rb

require "spec_helper"

RSpec.describe "Admin::Currencies", type: :request do
  let!(:currency) { create(:currency, :active) }
  let!(:inactive_currency) { create(:currency, name: "Inactive currency", iso_code: "AAA") }

  context "when user is not logged in" do
    describe "GET /admin/currencies" do
      subject { get admin_currencies_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/currencies/active" do
      subject { get active_admin_currencies_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/currencies/inactive" do
      subject { get inactive_admin_currencies_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/currencies/new" do
      subject { get new_admin_currency_path }

      it { is_expected.to require_login }
    end

    describe "POST /admin/currencies" do
      subject { post admin_currencies_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/currencies/:uuid/edit" do
      subject { get edit_admin_currency_path(currency) }

      it { is_expected.to require_login }
    end

    describe "PUT|PATCH /admin/currencies/:uuid" do
      subject { put admin_currency_path(currency) }

      it { is_expected.to require_login }
    end

    describe "PATCH /admin/currencies/:uuid/activate" do
      subject { patch activate_admin_currency_path(currency) }

      it { is_expected.to require_login }
    end

    describe "PATCH /admin/currencies/:uuid/deactivate" do
      subject { patch deactivate_admin_currency_path(currency) }

      it { is_expected.to require_login }
    end

    describe "DELETE /admin/currencies/:uuid" do
      subject { delete admin_currency_path(currency) }

      it { is_expected.to require_login }
    end
  end

  context "when user is logged in" do
    include_context "login as admin"

    describe "GET /admin/currencies" do
      before { get admin_currencies_path }

      it "assigns @currencies" do
        expect(ivar(:currencies).reload).to include(currency)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/currencies/active" do
      before { get active_admin_currencies_path }

      it "checks if all currencies are active" do
        expect(ivar(:currencies)).to all(be_active)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/currencies/inactive" do
      before { get inactive_admin_currencies_path }

      it "checks if all currencies are inactive" do
        expect(ivar(:currencies)).to all(be_inactive)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/currencies/new" do
      before { get new_admin_currency_path }

      include_examples "initializes a new instance", :currency, ::Currency

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/currencies" do
      context "with valid attributes" do
        subject do
          post admin_currencies_path, params: {
            currency: attributes_for(:currency, name: "US Dollar", iso_code: "USD")
          }, as: :turbo_stream
        end

        include_examples "creates a new object", ::Currency

        it "returns :found status" do
          post admin_currencies_path, params: {
            currency: attributes_for(:currency, name: "US Dollar", iso_code: "USD")
          }, as: :turbo_stream

          expect(response).to have_http_status(:found)
        end

        it "redirects to listing page" do
          post admin_currencies_path, params: {
            currency: attributes_for(:currency, name: "US Dollar", iso_code: "USD")
          }, as: :turbo_stream

          expect(response).to redirect_to(admin_currencies_path)
        end

        it "sets flash message" do
          post admin_currencies_path, params: {
            currency: attributes_for(:currency, name: "US Dollar", iso_code: "USD")
          }, as: :turbo_stream

          ivar(:currency).reload
          follow_redirect!

          expect(flash[:notice]).to eq("Currency 'US Dollar' was successfully created.")
        end
      end

      context "with invalid attributes" do
        include_examples "does not change count of objects", ::Currency

        it "renders turbo stream to update turbo frame 'currency_form'" do
          post admin_currencies_path, params: {
            currency: attributes_for(:currency, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"currency_form\">")
        end

        it "sets flash message" do
          post admin_currencies_path, params: {
            currency: attributes_for(:currency, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Currency could not be created.")
        end
      end
    end

    describe "GET /admin/currencies/:uuid/edit" do
      before { get edit_admin_currency_path(currency) }

      it "assigns a currency to @currency" do
        expect(ivar(:currency)).to eq(currency)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PUT/PATCH /admin/currencies/:uuid" do
      context "with valid attributes" do
        before do
          put admin_currency_path(currency), params: {
            currency: attributes_for(:currency, name: "United States Dollar")
          }, as: :turbo_stream
        end

        it "locates the requested @currency" do
          expect(ivar(:currency)).to eq(currency)
        end

        it "updates the currency" do
          currency = ivar(:currency).reload
          expect(currency.name).to eq("United States Dollar")
        end

        it "redirects to listing page" do
          expect(response).to redirect_to(admin_currencies_path)
        end

        it "sets flash message" do
          expect(flash[:notice]).to eq("Currency 'United States Dollar' was successfully updated.")
        end
      end

      context "with invalid attributes" do
        before do
          put admin_currency_path(currency), params: {
            currency: attributes_for(:currency, name: "")
          }, as: :turbo_stream
        end

        it "does not update the currency" do
          ivar(:currency).reload
          expect(currency.name).to eq("Indian rupee")
        end

        it "renders turbo stream to update turbo frame 'currency_form'" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"currency_form\">")
        end

        it "sets flash message" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Currency could not be updated.")
        end
      end
    end

    describe "DELETE /admin/currencies/:uuid" do
      subject { delete admin_currency_path(currency) }

      context "with valid 'uuid'" do
        it "locates the requested @currency" do
          delete admin_currency_path(currency)
          expect(ivar(:currency)).to eq(currency)
        end

        include_examples "deletes an object", ::Currency

        it "redirects to listing page and sets flash message" do
          delete admin_currency_path(currency)
          expect(response).to redirect_to(admin_currencies_path)
        end

        it "sets flash message" do
          delete admin_currency_path(currency)
          expect(flash[:info]).to eq("Currency 'Indian rupee' was successfully destroyed.")
        end
      end

      context "with invalid 'uuid'" do
        before do
          allow(::Currencies::DestroyService).to receive(:call).and_return(
            ServiceResponse.error(message: "Currency 'Antihistamines' could not be destroyed.")
          )
        end

        include_examples "does not change count of objects", ::Currency
      end
    end

    describe "PATCH /admin/currencies/:uuid/activate" do
      context "when the activation is successful" do
        before do
          patch activate_admin_currency_path(inactive_currency)
        end

        it "activates the currency" do
          expect(inactive_currency.reload.is_active?).to be_truthy
        end

        it "sets a success flash message" do
          expect(flash[:notice]).to eq("Currency 'Inactive currency' was successfully activated.")
        end

        it "redirects to inactive currencies page" do
          expect(response).to redirect_to(inactive_admin_currencies_path)
        end
      end

      context "when the activation fails" do
        before do
          allow(::Currencies::ActivateService).to receive(:call).and_return(
            ServiceResponse.error(message: "Currency 'Inactive currency' could not be activated.")
          )
          patch activate_admin_currency_path(inactive_currency)
        end

        it "does not activate the currency" do
          expect(inactive_currency.reload.is_active?).to be_falsy
        end

        it "sets an alert flash message" do
          expect(flash[:alert]).to be_present
        end

        it "redirects to inactive currencies page" do
          expect(response).to redirect_to(inactive_admin_currencies_path)
        end
      end
    end

    describe "PATCH /admin/currencies/:uuid/deactivate" do
      context "when the deactivation is successful" do
        before do
          patch deactivate_admin_currency_path(currency)
        end

        it "deactivates the currency" do
          expect(currency.reload.is_active?).to be_falsy
        end

        it "sets a warning flash message" do
          expect(flash[:warning]).to eq("Currency 'Indian rupee' was successfully deactivated.")
        end

        it "redirects to currencies list page" do
          expect(response).to redirect_to(admin_currencies_path)
        end
      end

      context "when the deactivation fails" do
        before do
          allow(::Currencies::DeactivateService).to receive(:call).and_return(
            ServiceResponse.error(message: "Currency 'Indian rupee' could not be deactivated.")
          )
          patch deactivate_admin_currency_path(currency)
        end

        it "does not deactivate the currency" do
          expect(currency.reload.is_active?).to be_truthy
        end

        it "sets an alert flash message" do
          expect(flash[:alert]).to be_present
        end

        it "redirects to currencies list page" do
          expect(response).to redirect_to(admin_currencies_path)
        end
      end
    end
  end
end
