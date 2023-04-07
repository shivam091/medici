# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/requests/admin/packing_types_spec.rb

require "spec_helper"

RSpec.describe "Admin::PackingTypes", type: :request do
  let!(:packing_type) { create(:packing_type, :active) }
  let!(:inactive_packing_type) { create(:packing_type, name: "Inactive packing type") }

  context "when user is not logged in" do
    describe "GET /admin/packing-types" do
      subject { get admin_packing_types_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/packing-types/active" do
      subject { get active_admin_packing_types_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/packing-types/inactive" do
      subject { get inactive_admin_packing_types_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/packing-types/new" do
      subject { get new_admin_packing_type_path }

      it { is_expected.to require_login }
    end

    describe "POST /admin/packing-types" do
      subject { post admin_packing_types_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/packing-types/:uuid/edit" do
      subject { get edit_admin_packing_type_path(packing_type) }

      it { is_expected.to require_login }
    end

    describe "PUT|PATCH /admin/packing-types/:uuid" do
      subject { put admin_packing_type_path(packing_type) }

      it { is_expected.to require_login }
    end

    describe "PATCH /admin/packing-types/:uuid/activate" do
      subject { patch activate_admin_packing_type_path(packing_type) }

      it { is_expected.to require_login }
    end

    describe "PATCH /admin/packing-types/:uuid/deactivate" do
      subject { patch deactivate_admin_packing_type_path(packing_type) }

      it { is_expected.to require_login }
    end

    describe "DELETE /admin/packing-types/:uuid" do
      subject { delete admin_packing_type_path(packing_type) }

      it { is_expected.to require_login }
    end
  end

  context "when user is logged in" do
    include_context "login as admin"

    describe "GET /admin/packing-types" do
      before { get admin_packing_types_path }

      it "assigns @packing_types" do
        expect(ivar(:packing_types).reload).to include(packing_type)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/packing-types/active" do
      before { get active_admin_packing_types_path }

      it "checks if all packing types are active" do
        expect(ivar(:packing_types)).to all(be_active)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/packing-types/inactive" do
      before { get inactive_admin_packing_types_path }

      it "checks if all packing types are inactive" do
        expect(ivar(:packing_types)).to all(be_inactive)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/packing-types/new" do
      before { get new_admin_packing_type_path }

      include_examples "initializes a new instance", :packing_type, ::PackingType

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/packing-types" do
      context "with valid attributes" do
        subject do
          post admin_packing_types_path, params: {
            packing_type: attributes_for(:packing_type, name: "Sachets")
          }, as: :turbo_stream
        end

        include_examples "creates a new object", ::PackingType

        it "returns :found status" do
          post admin_packing_types_path, params: {
            packing_type: attributes_for(:packing_type, name: "Sachets")
          }, as: :turbo_stream

          expect(response).to have_http_status(:found)
        end

        it "redirects to listing page" do
          post admin_packing_types_path, params: {
            packing_type: attributes_for(:packing_type, name: "Sachets")
          }, as: :turbo_stream

          expect(response).to redirect_to(admin_packing_types_path)
        end

        it "sets flash message" do
          post admin_packing_types_path, params: {
            packing_type: attributes_for(:packing_type, name: "Sachets")
          }, as: :turbo_stream

          ivar(:packing_type).reload
          follow_redirect!

          expect(flash[:notice]).to eq("Packing type 'Sachets' was successfully created.")
        end
      end

      context "with invalid attributes" do
        include_examples "does not change count of objects", ::PackingType

        it "renders turbo stream to update turbo frame 'packing_type_form'" do
          post admin_packing_types_path, params: {
            packing_type: attributes_for(:packing_type, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"packing_type_form\">")
        end

        it "sets flash message" do
          post admin_packing_types_path, params: {
            packing_type: attributes_for(:packing_type, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Packing type could not be created.")
        end
      end
    end

    describe "GET /admin/packing-types/:uuid/edit" do
      before { get edit_admin_packing_type_path(packing_type) }

      it "assigns a packing_type to @packing_type" do
        expect(ivar(:packing_type)).to eq(packing_type)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PUT/PATCH /admin/packing-types/:uuid" do
      context "with valid attributes" do
        before do
          put admin_packing_type_path(packing_type), params: {
            packing_type: attributes_for(:packing_type, name: "Cartons")
          }, as: :turbo_stream
        end

        it "locates the requested @packing_type" do
          expect(ivar(:packing_type)).to eq(packing_type)
        end

        it "updates the packing_type" do
          packing_type = ivar(:packing_type).reload
          expect(packing_type.name).to eq("Cartons")
        end

        it "redirects to listing page" do
          expect(response).to redirect_to(admin_packing_types_path)
        end

        it "sets flash message" do
          expect(flash[:notice]).to eq("Packing type 'Cartons' was successfully updated.")
        end
      end

      context "with invalid attributes" do
        before do
          put admin_packing_type_path(packing_type), params: {
            packing_type: attributes_for(:packing_type, name: "")
          }, as: :turbo_stream
        end

        it "does not update the packing_type" do
          ivar(:packing_type).reload
          expect(packing_type.name).to eq("Bottles")
        end

        it "renders turbo stream to update turbo frame 'packing_type_form'" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"packing_type_form\">")
        end

        it "sets flash message" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Packing type could not be updated.")
        end
      end
    end

    describe "DELETE /admin/packing-types/:uuid" do
      subject { delete admin_packing_type_path(packing_type) }

      context "with valid 'uuid'" do
        it "locates the requested @packing_type" do
          delete admin_packing_type_path(packing_type)
          expect(ivar(:packing_type)).to eq(packing_type)
        end

        include_examples "deletes an object", ::PackingType

        it "redirects to listing page" do
          delete admin_packing_type_path(packing_type)
          expect(response).to redirect_to(admin_packing_types_path)
        end

        it "sets flash message" do
          delete admin_packing_type_path(packing_type)
          expect(flash[:info]).to eq("Packing type 'Bottles' was successfully destroyed.")
        end
      end

      context "with invalid 'uuid'" do
        before do
          allow(::PackingTypes::DestroyService).to receive(:call).and_return(
            ServiceResponse.error(message: "Packing type 'Bottles' could not be destroyed.")
          )
        end

        include_examples "does not change count of objects", ::PackingType
      end
    end

    describe "PATCH /admin/packing-types/:uuid/activate" do
      context "when the activation is successful" do
        before do
          patch activate_admin_packing_type_path(inactive_packing_type)
        end

        it "activates the packing type" do
          expect(inactive_packing_type.reload.is_active?).to be_truthy
        end

        it "sets a success flash message" do
          expect(flash[:notice]).to eq("Packing type 'Inactive packing type' was successfully activated.")
        end

        it "redirects to inactive packing types page" do
          expect(response).to redirect_to(inactive_admin_packing_types_path)
        end
      end

      context "when the activation fails" do
        before do
          allow(::PackingTypes::ActivateService).to receive(:call).and_return(
            ServiceResponse.error(message: "Packing type 'Inactive packing type' could not be activated.")
          )
          patch activate_admin_packing_type_path(inactive_packing_type)
        end

        it "does not activate the packing type" do
          expect(inactive_packing_type.reload.is_active?).to be_falsy
        end

        it "sets an alert flash message" do
          expect(flash[:alert]).to be_present
        end

        it "redirects to inactive packing types page" do
          expect(response).to redirect_to(inactive_admin_packing_types_path)
        end
      end
    end

    describe "PATCH /admin/packing-types/:uuid/deactivate" do
      context "when the deactivation is successful" do
        before do
          patch deactivate_admin_packing_type_path(packing_type)
        end

        it "deactivates the packing type" do
          expect(packing_type.reload.is_active?).to be_falsy
        end

        it "sets a warning flash message" do
          expect(flash[:warning]).to eq("Packing type 'Bottles' was successfully deactivated.")
        end

        it "redirects to packing types list page" do
          expect(response).to redirect_to(admin_packing_types_path)
        end
      end

      context "when the deactivation fails" do
        before do
          allow(::PackingTypes::DeactivateService).to receive(:call).and_return(
            ServiceResponse.error(message: "Packing type 'Bottles' could not be deactivated.")
          )
          patch deactivate_admin_packing_type_path(packing_type)
        end

        it "does not deactivate the packing type" do
          expect(packing_type.reload.is_active?).to be_truthy
        end

        it "sets an alert flash message" do
          expect(flash[:alert]).to be_present
        end

        it "redirects to packing types list page" do
          expect(response).to redirect_to(admin_packing_types_path)
        end
      end
    end
  end
end
