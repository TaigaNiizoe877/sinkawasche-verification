# frozen_string_literal: true

class Customer < ApplicationRecord
  include Discard::Model
  include Request::RequestGeo
  has_secure_password validations: false

  has_many :working_locations
  has_many :reservations

  before_validation :set_lon_lat

  validates :family_name, presence: true
  validates :name, presence: true
  validates :family_name_kana, presence: true, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: "はカタカナで入力して下さい。" }
  validates :name_kana, presence: true, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: "はカタカナで入力して下さい。" }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates_uniqueness_of :email, conditions: -> { where(discarded_at: nil) }
  validates :prefecture, presence: true
  validates :address_first, presence: true
  validates :address_second, presence: true
  validates :aware_route, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  validates :phone, presence: true
  validates_uniqueness_of :phone, conditions: -> { where(discarded_at: nil) }
  validate :phone_number_check?
  validates :postal_code, presence: true
  validate :postal_code_check?

  enum aware_route: { home_page: "home_page", flyer: "flyer", review: "review", introduction: "introduction", other: "other" }

  def create_reset_digest
    self.reset_token = Customer.new_token
    update_attribute(:reset_digest,  Customer.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    CustomerMailer.reset_password(self).deliver_now
  end

  # welcomeメールを送信する
  def send_welcome_email
    CustomerMailer.welcome(self).deliver_now
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(reset_token)
    return false if reset_digest.nil?
    BCrypt::Password.new(reset_digest).is_password?(reset_token)
  end

  def full_name
    "#{family_name} #{name}"
  end

  def full_name_kana
    "#{family_name_kana} #{name_kana}"
  end

  def full_address
    "#{prefecture} #{address_first} #{address_second} #{building}"
  end

  def check_have_reservation
    errors.add(:base, "予約に紐づいているため、削除できません") if reservations.present?
  end

  def creation_working_location
    self.working_locations.build(
      postal_code: self.postal_code,
      prefecture: self.prefecture,
      address_first: self.address_first,
      address_second: self.address_second,
      building:  self.building
    )
    self.save
  end

  private
    def phone_number_check?
      return true if phone.blank?
      return errors.add(:phone, ": -(ハイフン)は入れないでください") if phone.match?(/[-]/)
      return errors.add(:phone, ": 10または11桁にしてください") unless phone.match?(/\A\d{10,11}\z/)
    end

    def postal_code_check?
      return true if postal_code.blank?
      return errors.add(:postal_code, ": -(ハイフン)は入れないでください") if postal_code.match?(/[-]/)
      return errors.add(:postal_code, ": 7桁にしてください") unless postal_code.match?(/\A\d{7}\z/)
    end

    def set_lon_lat
      return unless postal_code_changed?
      self.longitude, self.latitude = get_geo(postal_code).values
    end

    def self.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
end
