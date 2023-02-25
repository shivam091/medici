# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Stores::DestroyService < ApplicationService
  def initialize(store)
    @store = store
  end

  def call
    destroy_store
  end

  private

  attr_reader :store

  def destroy_store
    if store.destroy
      ::ServiceResponse.success(
        message: t("stores.destroy.success", store_name: store.name),
        payload: {store: store}
      )
    else
      ::ServiceResponse.error(
        message: t("stores.destroy.success", store_name: store.name),
        payload: {store: store}
      )
    end
  end
end
