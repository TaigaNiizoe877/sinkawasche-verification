# frozen_string_literal: true

class Staff < ApplicationRecord
  include Discard::Model
  include Request::RequestGeo

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_many :reservations
  has_many :staff_shifts

  validates :family_name, presence: true
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :role, presence: true

  validates :gender, presence: true, on: :update
  validates :phone, presence: true, if: :phone_number_check?, on: :update
  validates :postal_code, presence: true, if: :postal_code_check?, on: :update
  validates_uniqueness_of :phone, conditions: -> { where(discarded_at: nil) }, on: :update

  enum role: { admin: "admin", staff: "staff" }
  enum gender: { male: "male", female: "female", not_set: "not_set" }

  scope :role_staff, -> { where(role: "staff") }
  scope :role_admin, -> { where(role: "admin") }

  def self.active_staff_on_date(date)
    staffs = Staff.role_staff.filter_map do |staff|
      staff if staff.staff_shifts.where(start_at: date.all_day)
    end
    staff_ids = staffs.map(&:id)
    Staff.where(id: staff_ids)
  end

  def available(start_at, required_time, w_postal_code, res = nil)
    # 予約のupdateで使う場合は現在の予約を第四引数に渡す
    end_at = start_at + required_time
    return nil if role == "admin"
    return nil if staff_shifts.where(start_at: start_at.all_day).where("start_at <= ?", start_at).where("end_at >= ?", start_at + required_time).blank?
    return nil if reservations.where.not(id: res&.id).map { |res| (res.start_at <= start_at && start_at <= res.end_at) || (res.start_at <= end_at && end_at <= res.end_at) }.include?(true)
    self if check_available_outbound(start_at, w_postal_code, res) && check_available_inbound(start_at, required_time, w_postal_code, res)
  end

  def full_name
    "#{family_name} #{name}"
  end

  def full_address
    "#{prefecture} #{address}"
  end

  def check_have_reservation
    errors.add(:base, "予約に紐づいているため、削除できません") if reservations.present?
  end

  private
    def phone_number_check?
      return true if phone.blank?
      return errors.add(:phone, "-(ハイフン)は入れないでください") if phone.match?(/[-]/)
      return errors.add(:phone, "10または11桁にしてください") unless phone.match?(/\A\d{10,11}\z/)
    end

    def postal_code_check?
      return true if postal_code.blank?
      return errors.add(:postal_code, "-(ハイフン)は入れないでください") if postal_code.match?(/[-]/)
      return errors.add(:postal_code, "7桁にしてください") unless postal_code.match?(/\A\d{7}\z/)
    end

    def check_available_outbound(start_at, w_postal_code, res = nil)
      # 事前の予約から間に合うか
      before_reservation = reservations.where.not(id: res&.id).where(end_at: start_at.beginning_of_day..start_at).sort_by { |re| re.end_at }.last
      # initialize
      before_end_at = staff_shifts.find_by(start_at: start_at.all_day).start_at # 事前の予約がなければシフトの開始時間
      outbound_time = 0.minutes # 事前の予約がなければ移動時間なし

      if before_reservation.present?
        before_end_at, before_w_postal_code = [before_reservation.end_at, before_reservation.working_location.postal_code]
        outbound_time = travel_time(before_w_postal_code, w_postal_code).minutes + buffer_time.minutes
      end
      (before_end_at + outbound_time) <= start_at
    end

    def check_available_inbound(start_at, required_time, w_postal_code, res = nil)
      # 事後の予約に間に合うか
      after_reservation = reservations.where.not(id: res&.id).where(start_at: start_at..start_at.end_of_day).sort_by { |re| re.start_at }.first
      # initialize
      after_start_at = staff_shifts.find_by(start_at: start_at.all_day).end_at # 事後の予約がなければシフトの終了時間
      inbound_time = 0.minutes # 事後の予約がなければ移動時間なし

      if after_reservation.present?
        after_start_at, after_w_postal_code = [after_reservation.start_at, after_reservation.working_location.postal_code]
        inbound_time = travel_time(w_postal_code, after_w_postal_code).to_i.minutes + buffer_time.minutes
      end
      current_end_at = start_at + required_time

      (current_end_at + inbound_time) <= after_start_at
    end
end
