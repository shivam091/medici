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

  concern :reviewable do
    collection do
      get :pending
      get :approved
      get :rejected
    end

    member do
      patch :approve
      patch :reject
    end
  end

  concern :toggleable do
    collection do
      get :active
      get :inactive
    end

    member do
      patch :activate
      patch :deactivate
    end
  end

  concern :shareable do
    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]

    resources :expenses, param: :uuid, concerns: :reviewable
    resources *[
      :customers,
      :suppliers,
      :manufacturers,
      :medicines
    ], param: :uuid, concerns: :toggleable
  end

  authenticate :user, -> (user) { user.admin? } do
    namespace :admin do
      concerns :shareable

      resources *[
        :currencies,
        :countries,
        :ingredients,
        :shifts,
        :discounts
      ], except: :show, param: :uuid, concerns: :toggleable

      resources :stores, param: :uuid, concerns: :toggleable

      resources :users, param: :uuid, concerns: :toggleable do
        collection do
          get :banned
        end
      end

      resources :tax_rates, except: :show, param: :uuid, path: "tax-rates"
      resources :dosage_forms, except: :show, param: :uuid, path: "dosage-forms", concerns: :toggleable
      resources :medicine_categories, except: :show, param: :uuid, path: "medicine-categories", concerns: :toggleable
      resources :packing_types, except: :show, param: :uuid, path: "packing-types", concerns: :toggleable

      resources :purchase_orders, path: "purchase-orders", param: :uuid do
        resources :purchase_order_items, path: "purchase-order-items", param: :uuid, only: [:edit, :update, :destroy]

        collection do
          get :pending
          get :incomplete
          get :received
        end

        member do
          patch :mark_as_received, path: "mark-as-received"
        end
      end
    end
  end

  authenticate :user, -> (user) { user.manager? } do
    namespace :manager do
      concerns :shareable

      resources :purchase_orders, path: "purchase-orders", param: :uuid do
        resources :purchase_order_items, path: "purchase-order-items", param: :uuid, only: [:edit, :update, :destroy]

        collection do
          get :pending
          get :incomplete
          get :received
        end

        member do
          patch :mark_as_received, path: "mark-as-received"
        end
      end
    end
  end

  authenticate :user, -> (user) { user.cashier? } do
    namespace :cashier do
      concerns :shareable
    end
  end

  root to: "root#index"

  get "*unmatched_route", to: "application#not_found", format: false
end
