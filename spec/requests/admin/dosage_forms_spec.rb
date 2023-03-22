# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/requests/admin/dosage_forms_spec.rb

require "spec_helper"

RSpec.describe "Admin::DosageForms", type: :request do
  let!(:dosage_form) { create(:dosage_form, :active) }

  context "when user is not logged in" do
    describe "GET /admin/dosage-forms" do
      subject { get admin_dosage_forms_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/dosage-forms/new" do
      subject { get new_admin_dosage_form_path }

      it { is_expected.to require_login }
    end

    describe "POST /admin/dosage-forms" do
      subject { post admin_dosage_forms_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/dosage-forms/:uuid/edit" do
      subject { get edit_admin_dosage_form_path(dosage_form) }

      it { is_expected.to require_login }
    end

    describe "PUT|PATCH /admin/dosage-forms/:uuid" do
      subject { put admin_dosage_form_path(dosage_form) }

      it { is_expected.to require_login }
    end

    describe "DELETE /admin/dosage-forms/:uuid" do
      subject { delete admin_dosage_form_path(dosage_form) }

      it { is_expected.to require_login }
    end
  end

  context "when user is logged in" do
    context "when admin user is logged in" do
      include_context "login as admin"

      describe "GET /admin/dosage-forms" do
        before { get admin_dosage_forms_path }

        it "assigns @dosage_forms" do
          expect(ivar(:dosage_forms).reload).to match([dosage_form])
        end

        it "returns :ok status" do
          expect(response).to have_http_status(:ok)
        end
      end

      describe "GET /admin/dosage-forms/new" do
        before { get new_admin_dosage_form_path }

        include_examples "assigns a new object", :dosage_form, ::DosageForm

        it "returns :ok status" do
          expect(response).to have_http_status(:ok)
        end
      end

      describe "POST /admin/dosage-forms" do
        context "with valid attributes" do
          subject do
            post admin_dosage_forms_path, params: {
              dosage_form: attributes_for(:dosage_form, name: "Capsules")
            }, as: :turbo_stream
          end

          include_examples "creates a new object", ::DosageForm

          it "returns :found status" do
            post admin_dosage_forms_path, params: {
              dosage_form: attributes_for(:dosage_form, name: "Capsules")
            }, as: :turbo_stream

            expect(response).to have_http_status(:found)
          end

          it "redirects to listing page" do
            post admin_dosage_forms_path, params: {
              dosage_form: attributes_for(:dosage_form, name: "Capsules")
            }, as: :turbo_stream

            expect(response).to redirect_to(admin_dosage_forms_path)
          end

          it "sets flash message" do
            post admin_dosage_forms_path, params: {
              dosage_form: attributes_for(:dosage_form, name: "Capsules")
            }, as: :turbo_stream

            ivar(:dosage_form).reload
            follow_redirect!

            expect(flash[:notice]).to eq("Dosage form 'Capsules' was successfully created.")
          end
        end

        context "with invalid attributes" do
          include_examples "does not change count of objects", ::DosageForm

          it "renders turbo stream to update turbo frame 'dosage_form_form'" do
            post admin_dosage_forms_path, params: {
              dosage_form: attributes_for(:dosage_form, name: "")
            }, as: :turbo_stream

            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include("<turbo-stream action=\"update\" target=\"dosage_form_form\">")
          end

          it "sets flash message" do
            post admin_dosage_forms_path, params: {
              dosage_form: attributes_for(:dosage_form, name: "")
            }, as: :turbo_stream

            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
            expect(flash[:alert]).to eq("Dosage form could not be created.")
          end
        end
      end

      describe "GET /admin/dosage-forms/:uuid/edit" do
        before { get edit_admin_dosage_form_path(dosage_form) }

        it "assigns a dosage_form to @dosage_form" do
          expect(ivar(:dosage_form)).to eq(dosage_form)
        end

        it "returns :ok status" do
          expect(response).to have_http_status(:ok)
        end
      end

      describe "PUT/PATCH /admin/dosage-forms/:uuid" do
        context "with valid attributes" do
          before do
            put admin_dosage_form_path(dosage_form), params: {
              dosage_form: attributes_for(:dosage_form, name: "Inhalers")
            }, as: :turbo_stream
          end

          it "locates the requested @dosage_form" do
            expect(ivar(:dosage_form)).to eq(dosage_form)
          end

          it "updates the dosage_form" do
            dosage_form = ivar(:dosage_form).reload
            expect(dosage_form.name).to eq("Inhalers")
          end

          it "redirects to listing page" do
            expect(response).to redirect_to(admin_dosage_forms_path)
          end

          it "sets flash message" do
            expect(flash[:notice]).to eq("Dosage form 'Inhalers' was successfully updated.")
          end
        end

        context "with invalid attributes" do
          before do
            put admin_dosage_form_path(dosage_form), params: {
              dosage_form: attributes_for(:dosage_form, name: "")
            }, as: :turbo_stream
          end

          it "does not update the dosage_form" do
            ivar(:dosage_form).reload
            expect(dosage_form.name).to eq("Spray")
          end

          it "renders turbo stream to update turbo frame 'dosage_form_form'" do
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include("<turbo-stream action=\"update\" target=\"dosage_form_form\">")
          end

          it "sets flash message" do
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
            expect(flash[:alert]).to eq("Dosage form could not be updated.")
          end
        end
      end
    end

    context "when super admin is logged in" do
      include_context "login as super admin"

      describe "DELETE /admin/dosage-forms/:uuid" do
        subject { delete admin_dosage_form_path(dosage_form) }

        context "with valid 'uuid'" do
          it "locates the requested @dosage_form" do
            delete admin_dosage_form_path(dosage_form)
            expect(ivar(:dosage_form)).to eq(dosage_form)
          end

          include_examples "deletes an object", ::DosageForm

          it "redirects to listing page" do
            delete admin_dosage_form_path(dosage_form)
            expect(response).to redirect_to(admin_dosage_forms_path)
          end

          it "sets flash message" do
            delete admin_dosage_form_path(dosage_form)
            expect(flash[:info]).to eq("Dosage form 'Spray' was successfully destroyed.")
          end
        end

        context "with invalid 'uuid'" do
          before do
            allow(::DosageForms::DestroyService).to receive(:call).and_return(
              ServiceResponse.error(message: "Dosage form 'Spray' could not be destroyed.")
            )
          end

          include_examples "does not change count of objects", ::DosageForm
        end
      end
    end
  end
end
