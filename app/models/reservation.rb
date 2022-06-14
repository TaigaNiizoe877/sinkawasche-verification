# frozen_string_literal: true

class Reservation < ApplicationRecord
  include Discard::Model
  include Request::RequestGeo

  belongs_to :staff
  belongs_to :customer
  belongs_to :working_location
  has_many :reservation_infos
  has_many :request_changes

  # before_validation :recalculate_total_price
  before_validation :calculate_end_at, if: :new_record?

  accepts_nested_attributes_for :reservation_infos, allow_destroy: true
  accepts_nested_attributes_for :request_changes, allow_destroy: true
  accepts_nested_attributes_for :working_location

  enum status: { "applying": "applying", "approval": "approval", "completed": "completed", "cancel": "cancel" }

  validates :total_price, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :check_start_at
  validate :check_available_assgin

  def check_available_assgin
    return if staff.blank?
    errors.add(:base, "作業可能な時間ではありません。シフトと予約を確認して下さい。") if staff.available(start_at, calculate_required_time, working_location.postal_code, self).blank?
  end

  def self.vacancy(date)
    shift_minutes = StaffShift.where(start_at: date.all_day).map do |shift|
      (shift.end_at - shift.start_at) / 60
    end.sum
    return 0 if shift_minutes.zero?
    reservation_minutes = Reservation.where(start_at: date.all_day).map do |res|
      (res.end_at - res.start_at) / 60 + 30
    end.sum

    shift_minutes - reservation_minutes
  end

  def start_end_at_to_string
    "#{start_at.strftime("%Y年%m月%d日")}#{start_at.strftime("%H時%M分")} ~ #{end_at.strftime("%H時%M分")}"
  end

  def check_start_at
    return errors.add("三ヶ月より先の予約はできません") if start_at.present? && start_at > (Time.current + 3.months)
  end

  def recalculate_total_price
    calc_total_price = 0
    reservation_infos.each do |info|
      calc_total_price += info.car_wash_menu.price
      info.reservation_car_wash_options.each do |option|
        calc_total_price += option.car_wash_option.price
      end
    end
    calc_total_price += travel_fee.to_i
    return if total_price == calc_total_price

    self.total_price = calc_total_price
  end

  def calculate_end_at
    return nil if start_at.blank? || end_at.present?
    self.end_at = start_at + calculate_required_time.minutes
  end

  def calculate_required_time
    minutes = []
    reservation_infos.map(&:car_wash_menu).map do |menu|
      minutes << menu.required_time
    end

    reservation_infos.map(&:reservation_car_wash_options).flatten.map do |re_op|
      minutes << re_op.car_wash_option.required_time
    end

    required_minutes = minutes.sum
    required_minutes
  end

  def notification_reservation_just_to_slack
    notification_to_slack("予約情報です。ステータス：#{self.status_i18n} お客様：#{self.customer.full_name} 作業時刻：#{self.start_at.strftime('%Y/%m/%d')} #{self.start_at.strftime('%H:%M')} ~ #{self.end_at.strftime('%H:%M')}")
  end

  def notification_to_slack(message)
    notifier = Slack::Notifier.new(
      ENV["SLACK_WEBHOOK_URL"],
      username: "新添太雅"
    )
    notifier.ping message
  end
end

