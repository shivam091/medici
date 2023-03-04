# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class User < ApplicationRecord
  include CaseSensitivity,
          StripAttribute,
          DowncaseAttribute,
          Filterable,
          Sortable

  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :validatable, :timeoutable, :trackable,
         authentication_keys: {email: false, login: true}

  strip_attributes! :email
  downcase_attributes! :email

  attr_accessor :login, :password_required, :login_required

  THROTTLE_RESET_PERIOD = 2
  DEFAULT_PASSWORD_EXPIRY_PERIOD = 1.months.from_now

  attribute :is_banned, default: false
  attribute :is_active, default: false
  attribute :password_automatically_set, default: false

  validates :login, presence: true, if: :login_required?
  validates :password,
            presence: true,
            password: true,
            length: {in: 8..15},
            confirmation: {case_sensitive: false},
            reduce: true,
            if: :password_required?
  validates :password_confirmation,
            presence: true,
            reduce: true,
            if: :password_present?

  has_one :address, as: :addressable, dependent: :destroy

  has_many :request_logs, dependent: :nullify

  belongs_to :role
  belongs_to :store, optional: true

  delegate :name, to: :store, allow_nil: true, prefix: true
  delegate :name, to: :role, prefix: true
  delegate :country, to: :address
  delegate :name, to: :country, prefix: true

  default_scope { order_created_asc }

  accepts_nested_attributes_for :address, update_only: true

  class << self
    def with_email_or_mobile_number(login)
      iwhere(mobile_number: login.strip).or(iwhere(email: login.strip)).first
    end

    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      where(conditions).with_email_or_mobile_number(login)
    end

    def with_email(email)
      iwhere(email: email).first
    end

    def send_reset_password_instructions(attributes = {})
      recoverable = find_or_initialize_recoverable_with_errors(reset_password_keys, attributes, :not_found)
      recoverable.send_reset_password_instructions if recoverable.persisted?
      recoverable
    end

    def find_or_initialize_recoverable_with_errors(required_attributes, attributes, error = :invalid)
      attributes = attributes.slice(*required_attributes)
      login = attributes[:login]
      record = with_email_or_mobile_number(login)

      unless record
        record = new
        required_attributes.each do |key|
          value = attributes[key]
          record.send("#{key}=", value)
          if value.present?
            record.errors.add(key, error)
          else
            record.errors.add(key, :blank)
          end
        end
      end

      record.login = login
      record
    end
  end

  def full_name
    "#{try(:first_name)} #{try(:last_name)}"
  end

  def recently_sent_password_reset_instructions?
    reset_password_sent_at.present? && reset_password_sent_at >= THROTTLE_RESET_PERIOD.minute.ago
  end

  def active_for_authentication?
    super && is_active?
  end

  def admin?
    self.has_role?("admin")
  end

  def cashier?
    self.has_role?("cashier")
  end

  def manager?
    self.has_role?("manager")
  end

  def has_role?(role)
    role.eql?(self.role.name)
  end

  def has_any_role?(*roles)
    roles.include?(self.role.name)
  end

  def has_no_role?(role)
    !has_role?(role)
  end

  def has_no_roles?(*roles)
    !has_any_role?(*roles)
  end

  def address
    super.presence || build_address
  end

  private

  def password_present?
    password.present?
  end

  def password_required?
    !!password_required
  end

  def login_required?
    !!login_required
  end
end
