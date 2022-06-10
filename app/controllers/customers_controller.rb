# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_role_admin!

  def index
    customers = search_index(params)
    @customers = customers.order(created_at: "desc").page(params[:page]).per(30)
  end

  def show
    @customer = Customer.find_by(id: params[:id])
  end

  def new
    @customer = Customer.new
  end

  def create
    params[:customer][:password] = params[:customer][:email]
    @customer = Customer.new(customer_params)
    begin
      @customer.creation_working_location
      if @customer.save
        @customer.create_reset_digest
        @customer.send_welcome_email
        flash[:notice] = "お客様情報を作成しました。"
        redirect_to customers_path
      else
        render "new"
      end
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError, ActiveRecord::RecordInvalid => e
      Rails.logger.error("メール送信に失敗しました。システム担当者にご連絡ください。 #{e.message}")
      redirect_to customers_path, flash: { error: "メール送信に失敗しました。システム担当者にご連絡ください。 #{e.message}" }
    end
  end

  def edit
    @customer = Customer.find_by(id: params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:notice] = "お客様情報を更新しました"
      redirect_to customers_path
    else
      render "edit"
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.check_have_reservation
    if @customer.errors.blank? && @customer.discard
      flash[:notice] = "お客様情報を削除しました"
      redirect_to customers_path
    else
      errors = @customer.errors.full_messages
      errors.unshift("お客様情報を削除できませんでした。")
      flash[:errors] = errors
      redirect_to customers_path
    end
  end

  private
    def search_index(params)
      customer_ids = []
      customer_ids << Reservation.where("start_at >= ?", "#{params[:start_day].to_datetime.beginning_of_day}").pluck(:customer_id) if params[:start_day].present?
      customer_ids << Reservation.where("end_at <= ?", "#{params[:end_day].to_datetime.end_of_day}").pluck(:customer_id) if params[:end_day].present?
      customers = customer_ids.present? ? Customer.where(id: customer_ids&.uniq) : Customer.all
      params[:name]&.gsub("　", " ")&.split(" ")&.map do |str|
        customers = customers.where("family_name LIKE ?", "%#{str}%").or(customers.where("name LIKE ?", "%#{str}%"))
      end
      customers = customers.where(notice: true) if params[:public].eql?("1")
      customers = customers.where(notice: false) if params[:private].eql?("1")
      customers = customers.where(aware_route: params[:aware_route]) if params[:aware_route].present?
      # 住所あいまい検索
      params[:address]&.gsub(" ", ",")&.gsub("　", ",")&.gsub("、", ",")&.split(",")&.map do |str|
        customers = customers.where("prefecture LIKE ?", "%#{str}%").or(customers.where("address_first LIKE ?", "%#{str}%")).or(customers.where("building LIKE ?", "%#{str}%"))
      end

      customers
    end

    def customer_params
      params.require(:customer)
      .permit(
        :family_name, :name, :family_name_kana, :name_kana, :email, :password,
        :phone, :postal_code, :prefecture, :address_first, :address_second, :building, :memo, :aware_route,
        :latitude, :longitude, :notice, :reset_token, :reset_sent_at, :reset_digest
      )
    end
end
