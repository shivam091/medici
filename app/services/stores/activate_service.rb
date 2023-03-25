# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Stores::ActivateService < ApplicationService
  def initialize(store)
    @store = store
  end

  def call
    activate_store
  end

  private

  attr_reader :store

  def activate_store
    if store.activate!
      ::ServiceResponse.success(
        message: t("stores.activate.success", store_name: store.name),
        payload: {store: store}
      )
    else
      ::ServiceResponse.error(
        message: t("stores.activate.error", store_name: store.name),
        payload: {store: store}
      )
    end
  end
end
