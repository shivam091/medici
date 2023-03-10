# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  authenticate :user, -> (user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  mount ActionCable.server => "/cable"

  favicon_redirect = redirect do |_params, _request|
    ActionController::Base.helpers.asset_url(::Medici::Favicon.main)
  end

  get "favicon.png", to: favicon_redirect
  get "favicon.ico", to: favicon_redirect

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
    resource :dashboard, only: :show
    resources :customers, param: :uuid
  end

  authenticate :user, -> (user) { user.admin? } do
    namespace :admin do
      concerns :shareable

      resource :profile, only: [:show, :edit, :update]

      resources :currencies, :countries, :ingredients, :users, except: :show, param: :uuid

      resources :dosage_forms, except: :show, param: :uuid, path: "dosage-forms"
      resources :medicine_categories, except: :show, param: :uuid, path: "medicine-categories"
      resources :packing_types, except: :show, param: :uuid, path: "packing-types"

      resources :suppliers, :manufacturers, :medicines, :stores, param: :uuid
    end
  end

  authenticate :user, -> (user) { user.manager? } do
    namespace :manager do
      concerns :shareable

      resource :profile, only: [:show, :edit, :update]

      resources :suppliers, :manufacturers, :medicines, param: :uuid
    end
  end

  authenticate :user, -> (user) { user.cashier? } do
    namespace :cashier do
      concerns :shareable

      resource :profile, only: [:show, :edit, :update]
    end
  end

  root to: "root#index"

  get "*unmatched_route", to: "application#not_found", format: false
end
