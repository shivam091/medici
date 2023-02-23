# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Countries::CreateService < ApplicationService
  def initialize(country_attributes)
    @country_attributes = country_attributes.dup
  end

  def call
    create_country
  end

  private

  attr_reader :country_attributes

  def create_country
    country = ::Country.new(country_attributes)
    if country.save
      ::ServiceResponse.success(
        message: t("countries.create.success", country_name: country.name),
        payload: {country: country}
      )
    else
      ::ServiceResponse.error(
        message: t("countries.create.error"),
        payload: {country: country}
      )
    end
  end
end
