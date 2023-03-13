# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/requests/admin/medicine_categories_spec.rb

require "spec_helper"

RSpec.describe "Admin::MedicineCategories", type: :request do
  let!(:medicine_category) { create(:medicine_category, :active) }

  context "when user is not logged in" do
    describe "GET /admin/medicine-categories" do
      subject { get admin_medicine_categories_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/medicine-categories/new" do
      subject { get new_admin_medicine_category_path }

      it { is_expected.to require_login }
    end

    describe "POST /admin/medicine-categories" do
      subject { post admin_medicine_categories_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/medicine-categories/:uuid/edit" do
      subject { get edit_admin_medicine_category_path(medicine_category) }

      it { is_expected.to require_login }
    end

    describe "PUT|PATCH /admin/medicine-categories/:uuid" do
      subject { put admin_medicine_category_path(medicine_category) }

      it { is_expected.to require_login }
    end

    describe "DELETE /admin/medicine-categories/:uuid" do
      subject { delete admin_medicine_category_path(medicine_category) }

      it { is_expected.to require_login }
    end
  end

  context "when user is logged in" do
    include_context "login as admin"

    describe "GET /admin/medicine-categories" do
      before { get admin_medicine_categories_path }

      it "assigns @medicine_categories" do
        expect(ivar(:medicine_categories).reload).to match([medicine_category])
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/medicine-categories/new" do
      before { get new_admin_medicine_category_path }

      include_examples "assigns a new object", :medicine_category, ::MedicineCategory

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/medicine-categories" do
      context "with valid attributes" do
        subject do
          post admin_medicine_categories_path, params: {
            medicine_category: attributes_for(:medicine_category, name: "Antifungals")
          }, as: :turbo_stream
        end

        include_examples "creates a new object", ::MedicineCategory

        it "returns :found status" do
          post admin_medicine_categories_path, params: {
            medicine_category: attributes_for(:medicine_category, name: "Antifungals")
          }, as: :turbo_stream

          expect(response).to have_http_status(:found)
        end

        it "redirects to listing page" do
          post admin_medicine_categories_path, params: {
            medicine_category: attributes_for(:medicine_category, name: "Antifungals")
          }, as: :turbo_stream

          expect(response).to redirect_to(admin_medicine_categories_path)
        end

        it "sets flash message" do
          post admin_medicine_categories_path, params: {
            medicine_category: attributes_for(:medicine_category, name: "Antifungals")
          }, as: :turbo_stream

          ivar(:medicine_category).reload
          follow_redirect!

          expect(flash[:notice]).to eq("Medicine category 'Antifungals' was successfully created.")
        end
      end

      context "with invalid attributes" do
        include_examples "does not change count of objects", ::MedicineCategory

        it "renders turbo stream to update turbo frame 'medicine_category_form'" do
          post admin_medicine_categories_path, params: {
            medicine_category: attributes_for(:medicine_category, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"medicine_category_form\">")
        end

        it "sets flash message" do
          post admin_medicine_categories_path, params: {
            medicine_category: attributes_for(:medicine_category, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Medicine category could not be created.")
        end
      end
    end

    describe "GET /admin/medicine-categories/:uuid/edit" do
      before { get edit_admin_medicine_category_path(medicine_category) }

      it "assigns a medicine_category to @medicine_category" do
        expect(ivar(:medicine_category)).to eq(medicine_category)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PUT/PATCH /admin/medicine-categories/:uuid" do
      context "with valid attributes" do
        before do
          put admin_medicine_category_path(medicine_category), params: {
            medicine_category: attributes_for(:medicine_category, name: "Ambroxol")
          }, as: :turbo_stream
        end

        it "locates the requested @medicine_category" do
          ivar(:medicine_category).should eq(medicine_category)
        end

        it "updates the medicine_category" do
          medicine_category = ivar(:medicine_category).reload
          expect(medicine_category.name).to eq("Ambroxol")
        end

        it "redirects to listing page" do
          expect(response).to redirect_to(admin_medicine_categories_path)
        end

        it "sets flash message" do
          expect(flash[:notice]).to eq("Medicine category 'Ambroxol' was successfully updated.")
        end
      end

      context "with invalid attributes" do
        before do
          put admin_medicine_category_path(medicine_category), params: {
            medicine_category: attributes_for(:medicine_category, name: "")
          }, as: :turbo_stream
        end

        it "does not update the medicine_category" do
          ivar(:medicine_category).reload
          expect(medicine_category.name).to eq("Antihistamines")
        end

        it "renders turbo stream to update turbo frame 'medicine_category_form'" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"medicine_category_form\">")
        end

        it "sets flash message" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Medicine category could not be updated.")
        end
      end
    end

    describe "DELETE /admin/medicine-categories/:uuid" do
      subject { delete admin_medicine_category_path(medicine_category) }

      context "with valid 'uuid'" do
        it "locates the requested @medicine_category" do
          delete admin_medicine_category_path(medicine_category)
          expect(ivar(:medicine_category)).to eq(medicine_category)
        end

        include_examples "deletes an object", ::MedicineCategory

        it "redirects to listing page and sets flash message" do
          delete admin_medicine_category_path(medicine_category)
          expect(response).to redirect_to(admin_medicine_categories_path)
        end

        it "sets flash message" do
          delete admin_medicine_category_path(medicine_category)
          expect(flash[:info]).to eq("Medicine category 'Antihistamines' was successfully destroyed.")
        end
      end

      context "with invalid 'uuid'" do
        before do
          allow(::MedicineCategories::DestroyService).to receive(:call).and_return(
            ServiceResponse.error(message: "Medicine category 'Antihistamines' could not be destroyed.")
          )
        end

        include_examples "does not change count of objects", ::MedicineCategory
      end
    end
  end
end
