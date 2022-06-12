# frozen_string_literal: true

class CarSize < ApplicationRecord
  include Discard::Model

  has_one :reservation_info
  has_many :car_wash_options
  validates :name, presence: true
  validates :memo, presence: true

  # def check_have_menu_and_options
  #   return if discarded_at.nil?
  #   errors.add(:base, "洗車メニューに紐づいているため、削除できません") if car_wash_menus.present?
  #   errors.add(:base, "洗車オプションに紐づいているため、削除できません") if car_wash_menus.present?
  # end
end
