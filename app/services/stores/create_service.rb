# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Stores::CreateService < ApplicationService
  def initialize(store_attributes)
    @store_attributes = store_attributes.dup
  end

  def call
    create_store
  end

  private

  attr_reader :store_attributes

  def create_store
    store = ::Store.new(store_attributes)
    if store.save
      ::ServiceResponse.success(
        message: t("stores.create.success", store_name: store.name),
        payload: {store: store}
      )
    else
      ::ServiceResponse.error(
        message: t("stores.create.error"),
        payload: {store: store}
      )
    end
  end
end
