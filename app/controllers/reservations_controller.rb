# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_role_admin!, only: [:new, :create]

  def send_email
    @reservation = Reservation.find_by(id: params[:id])
    begin
      case @reservation.status
      when "approval"
        ReservationMailer.approval(@reservation).deliver_now
      when "cancel"
        ReservationMailer.cancel(@reservation).deliver_now
      when "completed"
        ReservationMailer.completed(@reservation).deliver_now
      end
      @reservation.update!({ sent_email: true })
      flash[:notice] = "メールを送信しました。"
      redirect_to reservation_path(@reservation)
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError, ActiveRecord::RecordInvalid => e
      Rails.logger.error("メール送信に失敗しました。システム担当者にご連絡ください。 #{e.message}")
      redirect_to reservation_path(@reservation), flash: { error: "メール送信に失敗しました。システム担当者にご連絡ください。 #{e.message}" }
    end
  end

  def index
    reservations = Reservation.where(customer_id: params[:customer_id]).presence || Reservation.all
    reservations = reservations.where(staff_id: current_staff.id) if current_staff.staff? # 自分の予約以外は閲覧不可
    reservations = search_index(params, reservations)

    @reservations = reservations.order(start_at: "desc").page(params[:page]).per(30)
  end

  def show
    @reservation = Reservation.find_by(id: params[:id])
    redirect_to reservations_path if current_staff.staff? && current_staff != @reservation.staff
  end

  def new
    @reservation = Reservation.new(customer_id: params[:customer_id])
  end

  def create
    target_params = reservation_params
    reject_unused_params(target_params)

    @reservation = Reservation.new(target_params)
    recalculate_total_price if @reservation.auto_culc_flag

    # ステータスが変わったら、メールステータス未送信にセット
    @reservation.sent_email = false if @reservation.status_changed?
    if @reservation.valid?
      @reservation.save
      flash[:notice] = "予約を作成しました"
      redirect_to reservation_path(@reservation)
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @current_staff = current_staff
    @reservation = Reservation.find_by(id: params[:id])
  end

  def update
    target_params = reservation_params
    reject_unused_params(target_params)

    @reservation = Reservation.find(params[:id])
    @reservation.assign_attributes(target_params)
    recalculate_total_price if @reservation.auto_culc_flag

    # ステータスが変わったら、メールステータス未送信にセット
    @reservation.sent_email = false if @reservation.changed? && @reservation.status != "applying"

    if @reservation.valid?
      @reservation.save
      flash[:notice] = "予約を更新しました"
      redirect_to reservation_path(@reservation)
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def request_read
    request_change = RequestChange.find_by(id: params[:request_change_id])
    request_change.update(status: params[:status])
    flash[:notice] = "既読に更新しました"
    redirect_to reservation_path(params[:id])
  end

  private
    def search_index(params, reservations = nil)
      # メニュー曖昧検索
      reservations = params[:menu_id].present? ? reservations.where(id: CarWashMenu.find_by(id: params[:menu_id])&.reservation_infos&.map(&:reservation_id)) : reservations
      # 名前曖昧検索
      customers = Customer.where(id: reservations.map(&:customer_id))
      params[:customer_name]&.gsub("　", " ")&.split(" ")&.map do |str|
        customer_ids = customers.where("family_name LIKE ?", "%#{str}%").or(customers.where("name LIKE ?", "%#{str}%"))
        reservations = reservations.where(customer_id: customer_ids.map(&:id))
      end
      # スタッフ
      staffs = Staff.where(id: reservations.map(&:staff_id))
      params[:staff_name]&.gsub("　", " ")&.split(" ")&.map do |str|
        staff_ids = (staffs.where("family_name LIKE ?", "%#{str}%").or(staffs.where("name LIKE ?", "%#{str}%")))
        reservations = reservations.where(staff_id: staff_ids.map(&:id))
      end
      reservations = reservations.where("start_at >= ?", "#{params[:start_day].to_datetime.beginning_of_day}") if params[:start_day].present?
      reservations = reservations.where("start_at <= ?", "#{params[:end_day].to_datetime.end_of_day}") if params[:end_day].present?
      # 住所あいまい検索
      wls = []
      params[:address]&.gsub(" ", ",")&.gsub("　", ",")&.gsub("、", ",")&.split(",")&.map do |str|
        wls = WorkingLocation.where(id: reservations.map(&:working_location_id))
        wls = wls.where("prefecture LIKE ?", "%#{str}%").or(wls.where("address LIKE ?", "%#{str}%")).or(wls.where("building LIKE ?", "%#{str}%"))
      end
      wl_ids = wls.pluck(:id)
      reservations = reservations.where(working_location_id: wl_ids) if params[:address].present?
      # ステータス
      reservations = reservations.where(status: params[:status]) if params[:status].present?
      reservations = reservations.where(status: params[:status]) if params[:status].present?
      # メール
      reservations = reservations.where(sent_email: true) if params[:done].eql?("1")
      reservations = reservations.where(sent_email: false) if params[:unsent].eql?("1")
      reservations
    end

    def reject_unused_params(target_params)
      target_params["reservation_infos_attributes"].each do |info|
        next if info.last["reservation_car_wash_options_attributes"].blank?

        info.last["reservation_car_wash_options_attributes"].each do |option|
          info.last["reservation_car_wash_options_attributes"].delete(option.first) if option.last["car_wash_option_id"].blank?
        end
      end
    end

    def reservation_params
      params.require(:reservation)
            .permit(
              :id, :customer_id, :working_location_id, :staff_id, :start_at, :end_at, :status, :total_price, :memo, :travel_fee, :auto_culc_flag,
              reservation_infos_attributes: [
                :id, :reservation_id, :car_size_id, :car_wash_menu_id, :car_model_name, :_destroy,
                reservation_car_wash_options_attributes: [
                  :id, :reservation_info_id, :car_wash_option_id, :_destroy
                ]
              ]
            )
    end

    def recalculate_total_price
      calc_total_price = 0
      @reservation.reservation_infos.each do |info|
        calc_total_price += info.car_wash_menu.price
        info.reservation_car_wash_options.select { |op| op._destroy == false }.each do |option|
          calc_total_price += option.car_wash_option.price
        end
      end
      calc_total_price += @reservation.travel_fee.to_i
      return if @reservation.total_price == calc_total_price

      @reservation.total_price = calc_total_price
    end
end
