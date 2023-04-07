# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/requests/admin/ingredients_spec.rb

require "spec_helper"

RSpec.describe "Admin::Ingredients", type: :request do
  let!(:ingredient) { create(:ingredient, :active) }
  let!(:inactive_ingredient) { create(:ingredient, name: "Inactive ingredient") }

  context "when user is not logged in" do
    describe "GET /admin/ingredients" do
      subject { get admin_ingredients_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/ingredients/active" do
      subject { get active_admin_ingredients_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/ingredients/inactive" do
      subject { get inactive_admin_ingredients_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/ingredients/new" do
      subject { get new_admin_ingredient_path }

      it { is_expected.to require_login }
    end

    describe "POST /admin/ingredients" do
      subject { post admin_ingredients_path }

      it { is_expected.to require_login }
    end

    describe "GET /admin/ingredients/:uuid/edit" do
      subject { get edit_admin_ingredient_path(ingredient) }

      it { is_expected.to require_login }
    end

    describe "PUT|PATCH /admin/ingredients/:uuid" do
      subject { put admin_ingredient_path(ingredient) }

      it { is_expected.to require_login }
    end

    describe "PATCH /admin/ingredients/:uuid/activate" do
      subject { patch activate_admin_ingredient_path(ingredient) }

      it { is_expected.to require_login }
    end

    describe "PATCH /admin/ingredients/:uuid/deactivate" do
      subject { patch deactivate_admin_ingredient_path(ingredient) }

      it { is_expected.to require_login }
    end

    describe "DELETE /admin/ingredients/:uuid" do
      subject { delete admin_ingredient_path(ingredient) }

      it { is_expected.to require_login }
    end
  end

  context "when user is logged in" do
    include_context "login as admin"

    describe "GET /admin/ingredients" do
      before { get admin_ingredients_path }

      it "assigns @ingredients" do
        expect(ivar(:ingredients).reload).to include(ingredient)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/ingredients/active" do
      before { get active_admin_ingredients_path }

      it "checks if all ingredients are active" do
        expect(ivar(:ingredients)).to all(be_active)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/ingredients/inactive" do
      before { get inactive_admin_ingredients_path }

      it "checks if all ingredients are inactive" do
        expect(ivar(:ingredients)).to all(be_inactive)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /admin/ingredients/new" do
      before { get new_admin_ingredient_path }

      include_examples "initializes a new instance", :ingredient, ::Ingredient

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/ingredients" do
      context "with valid attributes" do
        subject do
          post admin_ingredients_path, params: {
            ingredient: attributes_for(:ingredient, name: "Amoxycillin")
          }, as: :turbo_stream
        end

        include_examples "creates a new object", ::Ingredient

        it "returns :found status" do
          post admin_ingredients_path, params: {
            ingredient: attributes_for(:ingredient, name: "Amoxycillin")
          }, as: :turbo_stream

          expect(response).to have_http_status(:found)
        end

        it "redirects to listing page" do
          post admin_ingredients_path, params: {
            ingredient: attributes_for(:ingredient, name: "Amoxycillin")
          }, as: :turbo_stream

          expect(response).to redirect_to(admin_ingredients_path)
        end

        it "sets flash message" do
          post admin_ingredients_path, params: {
            ingredient: attributes_for(:ingredient, name: "Amoxycillin")
          }, as: :turbo_stream

          ivar(:ingredient).reload
          follow_redirect!

          expect(flash[:notice]).to eq("Ingredient 'Amoxycillin' was successfully created.")
        end
      end

      context "with invalid attributes" do
        include_examples "does not change count of objects", ::Ingredient

        it "renders turbo stream to update turbo frame 'ingredient_form'" do
          post admin_ingredients_path, params: {
            ingredient: attributes_for(:ingredient, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"ingredient_form\">")
        end

        it "sets flash message" do
          post admin_ingredients_path, params: {
            ingredient: attributes_for(:ingredient, name: "")
          }, as: :turbo_stream

          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Ingredient could not be created.")
        end
      end
    end

    describe "GET /admin/ingredients/:uuid/edit" do
      before { get edit_admin_ingredient_path(ingredient) }

      it "assigns a ingredient to @ingredient" do
        expect(ivar(:ingredient)).to eq(ingredient)
      end

      it "returns :ok status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PUT/PATCH /admin/ingredients/:uuid" do
      context "with valid attributes" do
        before do
          put admin_ingredient_path(ingredient), params: {
            ingredient: attributes_for(:ingredient, name: "Ambroxol")
          }, as: :turbo_stream
        end

        it "locates the requested @ingredient" do
          expect(ivar(:ingredient)).to eq(ingredient)
        end

        it "updates the ingredient" do
          ingredient = ivar(:ingredient).reload
          expect(ingredient.name).to eq("Ambroxol")
        end

        it "redirects to listing page" do
          expect(response).to redirect_to(admin_ingredients_path)
        end

        it "sets flash message" do
          expect(flash[:notice]).to eq("Ingredient 'Ambroxol' was successfully updated.")
        end
      end

      context "with invalid attributes" do
        before do
          put admin_ingredient_path(ingredient), params: {
            ingredient: attributes_for(:ingredient, name: "")
          }, as: :turbo_stream
        end

        it "does not update the ingredient" do
          ivar(:ingredient).reload
          expect(ingredient.name).to eq("Fluticasone furoate")
        end

        it "renders turbo stream to update turbo frame 'ingredient_form'" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"ingredient_form\">")
        end

        it "sets flash message" do
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"flash\">")
          expect(flash[:alert]).to eq("Ingredient could not be updated.")
        end
      end
    end

    describe "DELETE /admin/ingredients/:uuid" do
      subject { delete admin_ingredient_path(ingredient) }

      context "with valid 'uuid'" do
        it "locates the requested @ingredient" do
          delete admin_ingredient_path(ingredient)
          expect(ivar(:ingredient)).to eq(ingredient)
        end

        include_examples "deletes an object", ::Ingredient

        it "redirects to listing page" do
          delete admin_ingredient_path(ingredient)
          expect(response).to redirect_to(admin_ingredients_path)
        end

        it "sets flash message" do
          delete admin_ingredient_path(ingredient)
          expect(flash[:info]).to eq("Ingredient 'Fluticasone furoate' was successfully destroyed.")
        end
      end

      context "with invalid 'uuid'" do
        before do
          allow(::Ingredients::DestroyService).to receive(:call).and_return(
            ServiceResponse.error(message: "Ingredient 'Fluticasone furoate' could not be destroyed.")
          )
        end

        include_examples "does not change count of objects", ::Ingredient
      end
    end

    describe "PATCH /admin/ingredients/:uuid/activate" do
      context "when the activation is successful" do
        before do
          patch activate_admin_ingredient_path(inactive_ingredient)
        end

        it "activates the ingredient" do
          expect(inactive_ingredient.reload.is_active?).to be_truthy
        end

        it "sets a success flash message" do
          expect(flash[:notice]).to eq("Ingredient 'Inactive ingredient' was successfully activated.")
        end

        it "redirects to inactive ingredients page" do
          expect(response).to redirect_to(inactive_admin_ingredients_path)
        end
      end

      context "when the activation fails" do
        before do
          allow(::Ingredients::ActivateService).to receive(:call).and_return(
            ServiceResponse.error(message: "Ingredient 'Inactive ingredient' could not be activated.")
          )
          patch activate_admin_ingredient_path(inactive_ingredient)
        end

        it "does not activate the ingredient" do
          expect(inactive_ingredient.reload.is_active?).to be_falsy
        end

        it "sets an alert flash message" do
          expect(flash[:alert]).to be_present
        end

        it "redirects to inactive ingredients page" do
          expect(response).to redirect_to(inactive_admin_ingredients_path)
        end
      end
    end

    describe "PATCH /admin/ingredients/:uuid/deactivate" do
      context "when the deactivation is successful" do
        before do
          patch deactivate_admin_ingredient_path(ingredient)
        end

        it "deactivates the ingredient" do
          expect(ingredient.reload.is_active?).to be_falsy
        end

        it "sets a warning flash message" do
          expect(flash[:warning]).to eq("Ingredient 'Fluticasone furoate' was successfully deactivated.")
        end

        it "redirects to ingredients list page" do
          expect(response).to redirect_to(admin_ingredients_path)
        end
      end

      context "when the deactivation fails" do
        before do
          allow(::Ingredients::DeactivateService).to receive(:call).and_return(
            ServiceResponse.error(message: "Ingredient 'Fluticasone furoate' could not be deactivated.")
          )
          patch deactivate_admin_ingredient_path(ingredient)
        end

        it "does not deactivate the ingredient" do
          expect(ingredient.reload.is_active?).to be_truthy
        end

        it "sets an alert flash message" do
          expect(flash[:alert]).to be_present
        end

        it "redirects to ingredients list page" do
          expect(response).to redirect_to(admin_ingredients_path)
        end
      end
    end
  end
end
