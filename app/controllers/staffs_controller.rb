# frozen_string_literal: true

class StaffsController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_role_admin!, only: [:new, :create, :edit, :update, :destroy, :create_account]

  def index
    staffs = search_index(params)
    @staffs = staffs.order(created_at: "desc").page(params[:page]).per(30)
  end

  def show
    @staff = Staff.find(id: params[:id])
  end

  def new
    @staff = Staff.new
  end

  def create_account
    @staff = Staff.new(staff_params)
    begin
      if @staff.save
        StaffMailer.welcome(@staff).deliver_now
        flash[:notice] = "スタッフを作成しました。"
        redirect_to staffs_path
      else
        render "new"
      end
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError, ActiveRecord::RecordInvalid => e
      Rails.logger.error("メール送信に失敗しました。システム担当者にご連絡ください。 #{e.message}")
      redirect_to staffs_path, flash: { error: "メール送信に失敗しました。システム担当者にご連絡ください。 #{e.message}" }
    end
  end

  def edit
    @staff = Staff.find_by(id: params[:id])
  end

  def update
    @staff = Staff.find(params[:id])
    target_params = staff_params[:password].present? ? staff_params : update_without_current_password_params
    if @staff.update(target_params)
      flash[:notice] = "スタッフを更新しました"
      redirect_to staffs_path
    else
      render "edit"
    end
  end

  def destroy
    @staff = Staff.find(params[:id])
    @staff.check_have_reservation
    if @staff.errors.blank? && @staff.discard
      @staff.staff_shifts&.map(&:discard)
      flash[:notice] = "スタッフを削除しました"
      redirect_to staffs_path
    else
      errors = @staff.errors&.full_messages
      errors.unshift("スタッフを削除できませんでした。")
      flash.now[:errors] = errors

      redirect_to staffs_path
    end
  end

  private
    def search_index(params)
      staffs = Staff.all
      params[:name]&.gsub("　", " ")&.split(" ")&.map do |str|
        staffs = staffs.where("family_name LIKE ?", "%#{str}%").or(staffs.where("name LIKE ?", "%#{str}%"))
      end
      staffs = staffs.where(role: params[:role]) if params[:role].present?
      # 住所あいまい検索
      params[:address]&.gsub(" ", ",")&.gsub("　", ",")&.gsub("、", ",")&.split(",")&.map do |str|
        staffs = staffs.where("prefecture LIKE ?", "%#{str}%").or(staffs.where("address LIKE ?", "%#{str}%"))
      end
      staffs
    end

    def staff_params
      params.require(:staff)
            .permit(
              :family_name, :name, :email, :password, :password_confirmation, :role, :birthday,
              :phone, :gender, :postal_code, :prefecture, :address, :hobby, :memo, :buffer_time
            )
    end

    def update_without_current_password_params
      params.require(:staff)
            .permit(
              :family_name, :name, :email, :role, :birthday,
              :phone, :gender, :postal_code, :prefecture, :address, :hobby, :memo, :buffer_time
            )
    end
end
