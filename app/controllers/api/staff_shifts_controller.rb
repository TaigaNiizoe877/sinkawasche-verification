# frozen_string_literal: true

class Api::StaffShiftsController < ApplicationController
  def staff_shift_model_list
    staffs = params[:staff_id].present? ? Staff.where(id: params[:staff_id]) : Staff.where(role: "staff")
    model_list =
      if params[:start_at].present?
        StaffShift.all.where(staff_id: staffs.map(&:id), start_at: Time.parse(params[:start_at]).all_day).joins(:staff).select("staff_shifts.*, staffs.*").map do |shift|
          {
            start_date: shift.start_at.to_date.to_s,
            id: shift.id,
            start_end: shift.start_at.strftime("%H:%M") + " ~ " + shift.end_at.strftime("%H:%M"),
            staff_id: shift.staff.id,
            staff_name: shift.staff.full_name
          }
        end
      else
        StaffShift.all.joins(:staff).select("staff_shifts.*, staffs.*").map do |shift|
          {
            start_date: shift.start_at.to_date.to_s,
            id: shift.id,
            start_end: shift.start_at.strftime("%H:%M") + " ~ " + shift.end_at.strftime("%H:%M"),
            staff_id: shift.staff.id,
            staff_name: shift.staff.full_name
          }
        end
      end
    render json: model_list
  end
end
