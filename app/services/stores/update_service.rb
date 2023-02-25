# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Stores::UpdateService < ApplicationService
  def initialize(store, store_attributes)
    @store = store
    @store_attributes = store_attributes.dup
  end

  def call
    update_store
  end

  private

  attr_reader :store, :store_attributes

  def update_store
    if store.update(store_attributes)
      ::ServiceResponse.success(
        message: t("stores.update.success", store_name: store.name),
        payload: {store: store}
      )
    else
      ::ServiceResponse.error(
        message: t("stores.update.error"),
        payload: {store: store}
      )
    end
  end
end
