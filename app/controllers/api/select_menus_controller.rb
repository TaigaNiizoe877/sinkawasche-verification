# frozen_string_literal: true

class Api::SelectMenusController < ApplicationController
  def car_size_list
    size_list = CarSize.all.pluck(:id, :name, :memo)
    render json: size_list
  end

  def car_maker_list
    maker_list = CarMaker.all.pluck(:id, :name)
    render json: maker_list
  end

  def car_model_list
    model_list =
      if params[:car_maker_id].present?
        CarModel.where(car_maker_id: params[:car_maker_id]).pluck(:id, :name)
      else
        CarModel.all.pluck(:id, :name)
      end
    render json: model_list
  end

  def menu_and_option_list
    wash_menu_list = CarWashMenu.where(car_size_id: params[:car_size_id], status: true)
    wash_option_list = CarWashOption.where(car_size_id: params[:car_size_id], status: true)

    render json: [wash_menu: wash_menu_list, wash_option: wash_option_list]
  end

  # def working_location
  #   working_location = WorkingLocation.where(customer_id: params[:customer_id])
  #   render json: working_location
  # end

  def assignable_staff_list
    start_at = params[:start_at].present? ? Time.parse(params[:start_at]) : nil
    end_at = params[:end_at].present? ? Time.parse(params[:end_at]) : nil
    res = Reservation.find_by(id: params[:res_id])
    required_time = ((end_at.to_i - start_at.to_i) / 60).minutes if start_at.present? && end_at.present?
    w_postal_code = WorkingLocation.find_by(id: params[:working_location_id])&.postal_code

    assignable_staff_ids =
      if required_time.present? && w_postal_code.present? && start_at.to_date == end_at.to_date
        staffs = Staff.active_staff_on_date(start_at.to_date)
        staffs.filter_map { |staff| staff.available(start_at, required_time, w_postal_code, res) }&.map(&:id)
      else
        nil
      end
    assignable_staff_list = Staff.where(id: assignable_staff_ids)
    render json: assignable_staff_list
  end
end
