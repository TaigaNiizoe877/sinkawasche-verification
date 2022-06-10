# frozen_string_literal: true

class StaffShiftsController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_role_admin!, only: [:bulk_input, :bulk_chenge_input, :bulk_register]

  def calendar
    redirect_to staff_calendar_staff_shifts_path(staff_id: current_staff.id) if current_staff.staff?
    @staffs = Staff.where(role: "staff")
    @staff_shifts = StaffShift.where(staff_id: @staffs.map(&:id))
  end

  def staff_calendar
    @staff = Staff.find_by(id: params[:staff_id])
    redirect_to "/", flash: { error: "閲覧権限がありません。" } if current_staff != @staff
    @staff_shifts = @staff.staff_shifts
  end

  def bulk_input
    @staff = Staff.find_by(id: params[:staff_id])
    @input_data = set_input_data
    params[:times] = times
  end

  def bulk_chenge_input
    @staff = Staff.find_by(id: params[:staff_id])
    input_data = set_changed_input_data
    redirect_to bulk_input_staff_shifts_path(change_input_data: input_data, start_date: params[:start_date], staff_id: @staff.id)
  end

  def bulk_register
    attributes = set_bulk_attributes
    errors = []
    StaffShift.transaction do
      shifts = attributes.filter_map do |attribute|
        shift = StaffShift.find_by(id: attribute[:id])

        if attribute[:start_at].blank? && attribute[:end_at].blank?
          next if shift.blank?
          # 論理削除
          shift.discarded_at = Time.current
        else
          # 作成or更新
          shift = shift.presence || StaffShift.new
          shift.assign_attributes(attribute)
        end
        # errorメッセージの整形
        errors << "#{(shift.start_at.presence || shift.end_at.presence || shift.start_at_was.presence || shift.end_at_was.presence)&.strftime("%m月%d日")}:" + shift.errors.full_messages.join(",") if shift.present? && shift.invalid?

        shift
      end

      # 作成、更新、削除(descarded_atのupdate)のsave!
      shifts.map(&:save!)
    end
    redirect_to bulk_input_staff_shifts_path(start_date: params[:start_date], staff_id: params[:staff_id]), flash: { notice: "#{params[:start_date].to_date.strftime("%m月")}のシフトを更新しました。" }
  rescue ActiveRecord::RecordInvalid
    # flash
    errors.unshift("#{params[:start_date].to_date.strftime("%m月")}のシフトを更新できませんでした。もう一度やり直して下さい")
    flash[:errors] = errors.compact

    # paramsの整形
    input_hash = {}
    params[:data].to_unsafe_hash.values.map { |val| input_hash.store(val[:date], { start_at: val[:start_at], end_at: val[:end_at] }) }

    redirect_to bulk_input_staff_shifts_path(start_date: params[:start_date], staff_id: params[:staff_id], change_input_data: input_hash)
  end

  private
    def times
      start_date = Time.parse(params[:start_date] + " " + "09:00" + " " + "JST")
      times = 19.times.map do |i|
        start_date = start_date + 30.minutes unless i == 0
        [start_date.strftime("%H:%M")]
      end
      times
    end

    # input_data関連
    def set_changed_input_data
      wday = params[:wday]
      input_data = input_data_to_hash(params[:input_data]).presence || {}
      shifts = @staff.staff_shifts.where(start_at: params[:start_date].to_date.beginning_of_month.beginning_of_week..params[:start_date].to_date.end_of_month.end_of_week)
      bulk_start_at = params[:bulk_start_at]
      bulk_end_at = params[:bulk_end_at]
      (params[:start_date].to_time.to_datetime.beginning_of_month.beginning_of_week..params[:start_date].to_time.to_datetime.end_of_month.end_of_week).map(&:to_date).map do |date|
        if date.past? || !params[:start_date].to_time.to_date.all_month.include?(date) || wday[date.wday.to_s] == "0"
          # 過去の日付、表示月以外、または、適応しない曜日の場合、既存のデータを返す
          input_data.store(date.to_s, input_data[date.to_s])
          next
        end
        shifts.find_by(start_at: date.all_day)
        input_data.store(date.to_date.to_s,
          {
            start_at: bulk_start_at.present? ? Time.parse(date.to_s + " #{bulk_start_at}") : nil,
            end_at: bulk_end_at.present? ? Time.parse(date.to_s + " #{bulk_end_at}") : nil
          }
        )
      end
      input_data
    end

    def set_input_data
      input_data = {}
      shifts = @staff.staff_shifts.where(start_at: params[:start_date].to_date.beginning_of_month.beginning_of_week..params[:start_date].to_date.end_of_month.end_of_week)
      data = params[:change_input_data]&.to_unsafe_hash.presence || {}
      (params[:start_date].to_time.to_datetime.beginning_of_month.beginning_of_week..params[:start_date].to_time.to_datetime.end_of_month.end_of_week).map(&:to_date).map do |date|
        date_shift = shifts.find_by(start_at: date.all_day)
        input_data.store(date.to_s, data[date.to_s].presence ||
          {
            start_at: date_shift&.start_at,
            end_at: date_shift&.end_at
          }
        )
      end
      input_data
    end

    def input_data_to_hash(string)
      hash = {}
      string.split("/").map do |item|
        key, value = item.split("=>")
        start_at, end_at = value.split(",")
        hash.store(key,
          {
            start_at: start_at,
            end_at: end_at
          }
        )
      end
      hash
    end

    # attribute
    def set_bulk_attributes
      staff = Staff.find_by(id: params[:staff_id])
      params[:data].values.filter_map do |value|
        date, start_at, end_at = value.values
        {
          id: staff.staff_shifts.find_by(start_at: date.to_date.all_day)&.id,
          staff_id: staff.id,
          start_at: start_at.present? ? Time.parse(date + " #{start_at}") : nil,
          end_at: end_at.present? ? Time.parse(date + " #{end_at}") : nil
        }
      end
    end
end
