# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class User < ApplicationRecord
  include CaseSensitivity,
          StripAttribute,
          DowncaseAttribute,
          Filterable

  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :validatable, :timeoutable, :trackable,
         authentication_keys: {email: false, login: true}

  strip_attributes! :email
  downcase_attributes! :email

  attr_accessor :login, :password_required, :login_required

  THROTTLE_RESET_PERIOD = 2

  attribute :is_banned, default: false
  attribute :is_active, default: false
  attribute :password_automatically_set, default: false

  belongs_to :role
end
