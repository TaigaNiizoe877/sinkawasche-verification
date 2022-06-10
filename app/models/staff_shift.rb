# frozen_string_literal: true

class StaffShift < ApplicationRecord
  include Discard::Model

  belongs_to :staff

  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :check_assigned_reservations
  validate :check_date

  private
    def check_date
      return if start_at.nil? || end_at.nil?
      errors.add(:base, "過去のシフトは変更できません。") if start_at.to_date <= Time.current.yesterday.to_date || end_at.to_date <= Time.current.yesterday.to_date
    end

    def check_assigned_reservations
      return if start_at.nil? || end_at.nil?
      first_reservation = staff.reservations.where(start_at: start_at.all_day).order(start_at: "asc").first
      last_reservation = staff.reservations.where(start_at: start_at.all_day).order(start_at: "asc").last
      return if first_reservation.blank? && last_reservation.blank?
      errors.add(:base, "予約にアサインされているため、シフトを変更できません。") if first_reservation.start_at < start_at || end_at < last_reservation.end_at
    end
end
