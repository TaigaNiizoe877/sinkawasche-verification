# frozen_string_literal: true

class FormsController < ApplicationController
  include Request::RequestGeo
  layout "customer_form"
  before_action :set_session, only: [:select_menu, :select_day, :select_time, :input_info, :confirm]
  before_action :valid_to_have_session, only: [:select_day, :select_time, :input_info, :confirm]

  # 変更依頼トップ
  def request_change_top
    @reservation_id = params[:reservation_id]
    flash.now[:error] = "パスワードが正しくありません。" if params[:pas_error].present?
  end

  # 変更依頼ログイン
  def request_change_login
    redirect_to forms_request_change_top_path(reservation_id: params[:reservation_id], pas_error: true) and return unless Reservation.find_by(id: params[:reservation_id])&.customer.authenticate(params[:password])
    @customer = current_customer
    redirect_to forms_request_change_contact_path(customer: @customer, reservation_id: params[:reservation_id])
  end

  # 変更依頼フォーム
  def request_change_contact
    @customer = current_customer
  end

  # 変更依頼作成
  def creation_request_change
    @customer = current_customer
    if params[:reservation_type] == "cancel" && params[:cancel_memo].blank? || params[:reservation_type] == "change" && params[:change_memo].blank?
      flash.now[:errors] = []
      flash.now[:errors] << "キャンセル理由を入力してください。" if params[:reservation_type] == "cancel" && params[:cancel_memo].blank?
      flash.now[:errors] << "変更理由を入力してください。" if params[:reservation_type] == "change" && params[:change_memo].blank?
      render "request_change_contact"
    else
      request_change = RequestChange.new(
        reservation_id: params[:reservation_id],
        reservation_type: params[:reservation_type],
        memo: params[:cancel_memo].presence || params[:change_memo]
      )
      request_change.save
      flash[:notice] = "変更依頼が完了しました。＊変更またはキャンセルできない場合がございます。"
      ReservationMailer.change(request_change).deliver_now
      redirect_to forms_request_change_top_path(reservation_id: params[:reservation_id])
    end
  end

  def select_working_location
    @customer = current_customer
    @current_step = 0
  end

  def register_working_location
    @customer = current_customer
    @working_location = params[:working_location][:id] == "new" ? WorkingLocation.new : WorkingLocation.find_by(id: params[:working_location][:id])
    if @working_location.update(register_working_location_attributes)
      redirect_to forms_select_working_location_path, flash: { notice: "作業場所情報の保存に成功しました。" }
    else
      errors = @working_location.errors&.full_messages
      errors.unshift("作業場所情報の保存に失敗しました。")
      flash.now[:errors] = errors
      render :select_working_location
    end
  end

  def destroy_working_location
    @working_location = WorkingLocation.find_or_initialize_by(id: params[:working_location_id])
    @working_location.discard
    redirect_to forms_select_working_location_path
  end

  def help
  end

  def top
    massage = flash[:error]
    reset_session
    flash.now[:error] = massage
  end

  def select_menu
    @customer = current_customer
    if current_customer.present? && params[:w_id].blank? && session[:w_id].blank?
      redirect_to forms_select_working_location_path
    else
      initialize_session if current_customer.present?
      @current_step = 1
    end
  end

  def select_day
    if params[:start_date].present? && params[:start_date].to_date >= (Time.current + 3.months).end_of_month
      params[:start_date] = (Time.current.to_date + 3.months).to_s
      flash[:error] = "三ヶ月より先の予約はできません。"
    elsif params[:start_date].present? && params[:start_date].to_date.end_of_month < Time.current.beginning_of_month
      params[:start_date] = Time.current.to_date.to_s
      flash[:error] = "過去のカレンダーは閲覧できません"
    end

    if params[:reservation].present?
      data = params[:reservation].permit!
      flash.now[:errors] = []
      data.to_h.values.map { |val| (val["car_model_name"].presence || val["car_maker_id"].presence && val["car_model_id"]).blank? }.each.with_index(1) do |empty, i|
        flash.now[:errors] << "#{i}台目の車種を選択または、車種名を入力ください" if empty
      end
      if flash.now[:errors].present?
        @current_step = 1
        render "select_menu"
      end
    end

    @current_step = 2
  end

  def select_time
    redirect_to forms_select_day_path, flash: { error: "#{params[:day].to_date.strftime("%m月%d日")}に空き枠がありませんでした。日付選択からやり直してください。" } unless session[:time_schedule].map { |sche| sche.second.present? }.include?(true)

    @current_step = 3
  end

  def input_info
    @current_step = 4
  end

  def confirm
    @reservation = Reservation.new(reservation_attributes)
    if @reservation.staff.blank? # 担当できるスタッフが存在しない
      redirect_to forms_select_day_path, flash: { error: "入力中に予約が埋まってしまいました。日付選択からやり直してください。" }
    else
      @customer = @reservation.customer.presence || @reservation.build_customer
      @customer.assign_attributes(customer_attributes)
      @reservation.build_working_location(working_location_attributes)
      redirect_to forms_input_info_path, flash: { errors: error_full_message } if @customer.invalid? || @reservation.invalid?
    end
    @current_step = 5
  end

  def apply_reservation
    @reservation = Reservation.new(reservation_attributes)
    if @reservation.staff.blank?
      redirect_to forms_select_day_path, flash: { error: "入力中に予約が埋まってしまいました。日付選択からやり直してください。" }
    else
      @customer = @reservation.customer.presence || @reservation.build_customer
      WorkingLocation.find_by(id: session[:w_id]).blank? ? @reservation.build_working_location(working_location_attributes) : @reservation.working_location_id = session[:w_id]
      Reservation.transaction do
        @customer.update!(customer_attributes)
        session[:customer_id] = @customer.id
        @reservation.save!
      end

      ReservationMailer.apply(@reservation).deliver_now && @reservation.update!({ sent_email: true })
      redirect_to forms_success_path(id: @reservation)
    end
  rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError, ActiveRecord::RecordInvalid => e
    error_full_message << e.full_message if e.full_message.present?
    redirect_to forms_top_path, flash: { errors: error_full_message }
  end

  def success
    @reservation = Reservation.find_by(id: params[:id])
    @customer = @reservation.customer
    if current_customer.blank? || current_customer.id != @customer.id
      reset_session
      redirect_to forms_top_path, flash: { error: "不正な遷移です。初めからやり直して下さい" }, data: { turbo: false }
    else
      reset_session
    end
  end

  private
    def set_session
      set_session_for_select_menus
      return if session[:w_postal_code].blank?

      set_session_for_select_day
      set_session_for_select_time
      set_session_for_input_info
    end

    def calculate_required_time
      minutes = []
      session[:select_menus].map do |menu|
        minutes << CarWashMenu.find_by(id: menu[:car_wash_menu_id])&.required_time
        minutes << CarWashOption.where(id: menu[:car_wash_option_ids]&.values&.map { |option| option.values }&.flatten).map(&:required_time).sum
      end
      required_minutes = minutes.sum
      required_minutes
    end

    def calculate_total_price
      price = []
      session[:select_menus].map do |menu|
        price << CarWashMenu.find_by(id: menu[:car_wash_menu_id]).price
        price << CarWashOption.where(id: menu[:car_wash_option_ids]&.values&.map { |option| option.values }&.flatten).map(&:price).sum
      end
      price << session[:travel_fee]&.price.to_i
      price.sum
    end

    # 以下attributes関連
    def reservation_attributes
      staff_id = nil
      Staff.where(id: session[:staff_ids]).map do |staff|
        next if staff_id.present?
        staff = staff.available(session[:start_at], session[:required_time].minutes, session[:w_postal_code])

        staff_id = staff.id if staff.present?
      end

      result = {
        customer: current_customer,
        start_at: session[:start_at],
        memo: session[:memo],
        total_price: session[:total_price],
        travel_fee: session[:travel_fee]&.price
      }
      result.store(:reservation_infos_attributes, reservation_infos_attributes) if reservation_infos_attributes.present?
      result.store(:staff_id, staff_id) if staff_id.present?
      result
    end

    def reservation_infos_attributes
      session[:select_menus]&.map do |menu|
          car_wash_option_ids = menu[:car_wash_option_ids]&.values&.map { |option| option.values }&.flatten
          return_hash = {
            car_size_id: menu[:car_size_id],
            car_model_name: menu[:car_model_name].presence || CarModel.find(menu[:car_model_id]).name,
            car_wash_menu_id: menu[:car_wash_menu_id]
          }
          if car_wash_option_ids.present?
            option_hash = {
              reservation_car_wash_options_attributes: car_wash_option_ids.filter_map { |option_id|
                { car_wash_option_id: option_id }
              }
            }
            return_hash.merge!(option_hash)
          end
          return_hash
        end
      end

    def working_location_attributes
      {
        customer: @customer,
        postal_code: session[:w_postal_code],
        prefecture: session[:w_prefecture],
        address_first: session[:w_address_1],
        address_second: session[:w_address_2],
        building: session[:w_building]
      }
    end

    def register_working_location_attributes
      params[:working_location][:prefecture], params[:working_location][:address_first] = params["#{params[:working_location][:id]}_prefecture"], params["#{params[:working_location][:id]}_address_first"]
      params.require("working_location").permit(:customer_id, :postal_code, :prefecture, :address_first, :address_second, :building)
    end

    def customer_attributes
      memo = current_customer&.memo.presence || ""
      memo = memo + "\n#{session[:memo]}" if session[:memo].present?
      result = {
        family_name: session[:family_name],
        name: session[:name],
        family_name_kana: session[:family_name_kana],
        name_kana: session[:name_kana],
        phone: session[:phone],
        email: session[:email],
        memo: memo,
        postal_code: session[:postal_code],
        prefecture: session[:prefecture],
        address_first: session[:address_1],
        address_second: session[:address_2],
        building: session[:building],
        aware_route: session[:aware_route],
        notice: session[:notice]
      }
      result.store(:password_digest, session[:password_digest]) if session[:password_digest].present?
      result
    end

    # 以下セッション関連
    def set_session_for_select_menus
      return if params[:reservation].blank?

      session[:w_postal_code] = params[:w_postal_code]
      session[:w_prefecture] = params[:w_prefecture]
      session[:w_address_1] = params[:w_address_1]
      session[:w_lon], session[:w_lat] = get_geo(session[:w_postal_code]).values
      session[:select_menus] = (params[:reservation].permit!).to_h.values
      session[:required_time] = calculate_required_time
    end

    def set_session_for_select_day
      return if params[:day].blank?

      session[:day] = params[:day]
      session[:time_schedule] = time_schedule
    end

    def set_session_for_select_time
      return if params[:staff_ids].blank?

      session[:staff_ids] = params[:staff_ids]&.map(&:to_i)
      session[:start_at] = Time.parse(session[:day] + " " + params[:time] + " " + "JST")
      session[:end_at] = session[:start_at] + calculate_required_time.minutes
    end

    def set_session_for_input_info
      return if params[:w_address_2].blank?

      # お客様情報
      session[:family_name] = params[:family_name]
      session[:name] = params[:name]
      session[:family_name_kana] = params[:family_name_kana]
      session[:name_kana] = params[:name_kana]
      session[:phone] = params[:phone]
      session[:email] = params[:email]
      session[:postal_code] = params[:postal_code]
      session[:prefecture] = params[:prefecture]
      session[:address_1] = params[:address_1]
      session[:address_2] = params[:address_2]
      session[:building] = params[:building]
      session[:aware_route] = params[:aware_route]
      session[:notice] = params[:notice]
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      session[:password_digest] = BCrypt::Password.create(params[:password], cost: cost) if params[:password].present?
      # 予約情報
      session[:memo] = params[:memo]
      # 作業場所情報
      session[:w_address_2] = params[:w_address_2]
      session[:travel_fee] = TravelFee.search_travel_fees(params[:w_prefecture], params[:w_address_1] + params[:w_address_2])
      session[:w_building] = params[:w_building]
      # 金額
      session[:total_price] = calculate_total_price
    end

    def initialize_session
      # お客様情報
      if session[:family_name].blank?
        session[:family_name] = current_customer&.family_name
        session[:name] = current_customer&.name
        session[:family_name_kana] = current_customer&.family_name_kana
        session[:name_kana] = current_customer&.name_kana
        session[:phone] = current_customer&.phone
        session[:email] = current_customer&.email
        session[:postal_code] = current_customer&.postal_code
        session[:prefecture] = current_customer&.prefecture
        session[:address_1] = current_customer&.address_first
        session[:address_2] = current_customer&.address_second
        session[:building] = current_customer&.building
        session[:aware_route] = current_customer&.aware_route
      end
      # 作業場所
      working_location = WorkingLocation.find_by(id: params[:w_id])
      if working_location.present?
        session[:w_id] = working_location.id
        session[:w_postal_code] = working_location.postal_code
        session[:w_prefecture] = working_location.prefecture
        session[:w_address_1] = working_location.address_first
        session[:w_address_2] = working_location.address_second
        session[:w_building] = working_location.building
      end
    end
    # 以上セッション関連

    # その他
    def valid_to_have_session
      return if session[:w_postal_code].present?
      redirect_to forms_top_path, flash: { error: "不正な遷移です。初めからやり直して下さい" }, data: { turbo: false }
    end

    def error_full_message
      result = []
      result << "【予約内容】" if @reservation.errors.present?
      result << @reservation.errors.full_messages
      result << @reservation.working_location.errors.full_messages
      result << "【顧客情報】" if @customer.errors.present?
      result << @customer.errors.full_messages
      result.flatten
    end

    def time_schedule
      start_at = Time.parse(session[:day] + " " + "09:00" + " " + "JST")
      staffs = Staff.active_staff_on_date(session[:day].to_date)
      staff_ids = nil
      times = 19.times.map do |i|
        start_at = start_at + 30.minutes if i != 0
        staff_ids = staffs.filter_map { |staff| staff.available(start_at, session[:required_time].minutes, session[:w_postal_code]) }&.map(&:id)
        [start_at, staff_ids]
      end
      times
    end
end
