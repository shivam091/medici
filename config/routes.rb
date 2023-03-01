# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

Rails.application.routes.draw do
  favicon_redirect = redirect do |_params, _request|
    ActionController::Base.helpers.asset_url(::Medici::Favicon.main)
  end

  get "favicon.png", to: favicon_redirect
  get "favicon.ico", to: favicon_redirect

  root to: "cashier/dashboards#show"

  devise_for :users,
             path: "auth",
             path_names: {
               sign_in: "sign-in", sign_out: "sign-out", confirmation: "verification",
               sign_up: "sign-up"
             },
             controllers: {
               sessions: "user/sessions",
               confirmations: "user/confirmations",
               passwords: "user/passwords",
               unlocks: "user/unlocks",
               registrations: "user/registrations"
             }

  concern :shareable do
    resources :suppliers, param: :uuid
    resources :manufacturers, param: :uuid
    resources :medicines, param: :uuid
  end

  devise_scope :user do
    namespace :admin do
      concerns :shareable

      resource :dashboard

      resources :currencies, except: :show, param: :uuid
      resources :countries, except: :show, param: :uuid
      resources :ingredients, except: :show, param: :uuid
      resources :dosage_forms, except: :show, param: :uuid, path: "dosage-forms"
      resources :medicine_categories, except: :show, param: :uuid, path: "medicine-categories"
      resources :packing_types, except: :show, param: :uuid, path: "packing-types"
      resources :users, param: :uuid

      resources :stores, param: :uuid
    end

    namespace :cashier do
      resource :dashboard
    end

    namespace :manager do
      concerns :shareable

      resource :dashboard
    end
  end
end
