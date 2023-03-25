# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Stores::DeactivateService < ApplicationService
  def initialize(store)
    @store = store
  end

  def call
    deactivate_store
  end

  private

  attr_reader :store

  def deactivate_store
    if store.deactivate!
      ::ServiceResponse.success(
        message: t("stores.deactivate.success", store_name: store.name),
        payload: {store: store}
      )
    else
      ::ServiceResponse.error(
        message: t("stores.deactivate.error", store_name: store.name),
        payload: {store: store}
      )
    end
  end
end
