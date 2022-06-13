# frozen_string_literal: true

class CarWashMenu < ApplicationRecord
  include Discard::Model

  belongs_to :car_size
  has_many :reservation_infos

  validates :name, presence: true
  validates :price, presence: true
  validates :required_time, presence: true

  def price_jpy
    price.present? ? "¥#{price&.to_fs(:delimited)}" : ""
  end

  def check_have_reservation
    errors.add(:base, "予約に紐づいているため、削除できません") if reservation_infos.present?
  end
end
