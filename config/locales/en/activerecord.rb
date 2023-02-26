# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

{
  en: {
    activerecord: {
      attributes: {
        role: {
          name: "Name",
          is_active: "Is active"
        },
        user: {
          first_name: "First name",
          last_name: "Last name",
          login: "Email address or mobile number",
          remember_me: "Keep me signed in",
          password: "Password",
          password_confirmation: "Password confirmation",
          current_password: "Current password",
          email: "Email address",
          unconfirmed_email: "Unconfirmed email address",
          mobile_number: "Mobile number",
          unconfirmed_mobile_number: "Unconfirmed mobile number",
        },
        currency: {
          name: "Name",
          iso_code: "Code",
          symbol: "Symbol",
          subunit: "Sub unit",
          subunit_to_unit: "Sub units to unit",
          symbol_first: "Symbol first",
          decimal_mark: "Decimal mark",
          thousands_separator: "Thousands separator",
          is_active: "Is active",
          country_ids: "Countries",
        },
        country: {
          name: "Name",
          iso2: "Alpha-2 code",
          iso3: "Alpha-3 code",
          calling_code: "Calling code",
          has_postal_code: "Has postal code",
          is_active: "Is active",
          currency_id: "Currency",
        },
        ingredient: {
          name: "Name",
          description: "Description",
          is_active: "Is active",
        },
        dosage_form: {
          name: "Name",
          is_active: "Is active",
        },
        medicine_category: {
          name: "Name",
          description: "Description",
          is_active: "Is active",
        },
        address: {
          address1: "Flat, House no., Building, Company, Apartment, P.O. box, c/o",
          address2: "Area, Street, Sector, Village, Suite, or Floor",
          city: "Town, City, Suburb, or Area",
          region: "State, Province, County, or Territory",
          country_id: "Country",
          postal_code: "Postal code, Postcode, or PIN code",
        },
        store: {
          name: "Name",
          email: "Email address",
          phone_number: "Phone number",
          fax_number: "Fax number",
          is_active: "Is active",
          registration_number: "Registration number",
          logo: "Logo",
        },
        supplier: {
          name: "Name",
          email: "Email address",
          phone_number: "Phone number",
          is_active: "Is active",
        },
        manufacturer: {
          name: "Name",
          email: "Email address",
          phone_number: "Phone number",
          customer_care_number: "Customer care number",
          is_active: "Is active",
        }
      },
      help_texts: {

      },
      errors: {
        format: "%{attribute} %{message}",
        template: {
          body: "There were problems with the following fields:",
          header: {
            one: "Whoops! There was some problem with your input. Please fix it before continuing:",
            other: "Whoops! There were some problems with your inputs. Please fix them before continuing:"
          }
        },
        models: {

        },
        messages: {
          label_already_exists_at_group_level: "already exists at group level for %{group}. Please choose another one.",
          wrong_size: "is the wrong size (should be %{file_size})",
          size_too_small: "is too small (should be at least %{file_size})",
          size_too_big: "is too big (should be at most %{file_size})",
          accepted: "must be accepted",
          any_field: "At least one field of %{one_of_required_fields} must be present",
          blank: "is required",
          present: "must be blank",
          confirmation: "doesn't match %{attribute}",
          empty: "can't be empty",
          equal_to: "must be equal to %{count}",
          even: "must be even",
          exclusion: "is reserved",
          greater_than: "must be greater than %{count}",
          greater_than_or_equal_to: "must be greater than or equal to %{count}",
          inclusion: "is not included in the list",
          invalid: "is invalid",
          less_than: "must be less than %{count}",
          less_than_or_equal_to: "must be less than or equal to %{count}",
          model_invalid: "Validation failed: %{errors}",
          not_a_number: "must be a number",
          not_an_integer: "must be an integer",
          odd: "must be odd",
          required: "must exist",
          taken: "is already in use",
          too_long: {
            one: "is too long (maximum is 1 character)",
            other: "is too long (maximum is %{count} characters)"
          },
          too_short: {
            one: "is too short (minimum is 1 character)",
            other: "is too short (minimum is %{count} characters)"
          },
          wrong_length: {
            one: "must be exactly 1 character long",
            other: "must be exactly %{count} characters long"
          },
          other_than: "must be other than %{count}",
          record_invalid: "Validation failed: %{errors}",
          restrict_dependent_destroy: {
            has_one: "Cannot delete record because a dependent %{record} exists",
            has_many: "Cannot delete record because dependent %{record} exist"
          },
        }
      },
    }
  }
}
