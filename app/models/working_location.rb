# frozen_string_literal: true

class WorkingLocation < ApplicationRecord
  include Discard::Model
  include Request::RequestGeo

  belongs_to :customer
  has_many :reservations

  before_validation :set_lon_lat

  validates :prefecture, presence: true
  validates :address_first, presence: true
  validates :address_second, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  validates :postal_code, presence: true, if: :postal_code_check?

  def full_address
    bd = building.present? ? "(#{building})" : ""
    prefecture + address_first + address_second + bd
  end

  def postal_code_check?
    return true if postal_code.blank?
    return errors.add(:postal_code, "-(ハイフン)は入れないでください") if postal_code.match?(/[-]/)
    return errors.add(:postal_code, "7桁にしてください") unless postal_code.match?(/\A\d{7}\z/)
  end

  def check_have_reservation
    errors.add(:base, "予約に紐づいているため、削除できません") if reservations.present?
  end

  private
    def set_lon_lat
      return unless postal_code_changed?
      self.longitude, self.latitude = get_geo(postal_code).values
    end
end
