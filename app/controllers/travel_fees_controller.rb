# frozen_string_literal: true

class TravelFeesController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_role_admin!

  def index
    travel_fees = search_index(params)
    @travel_fees = travel_fees.order(created_at: "desc").page(params[:page]).per(30)
  end

  def show
    @car_wash_menu = TravelFee.find_by(id: params[:id])
  end

  def new
    @travel_fee = TravelFee.new
  end

  def create
    @travel_fee = TravelFee.new(travel_fee_params)
    if @travel_fee.save
      flash[:notice] = "出張料金を作成しました。"
      redirect_to travel_fees_path
    else
      render "new"
    end
  end

  def edit
    @travel_fee = TravelFee.find_by(id: params[:id])
  end

  def update
    @travel_fee = TravelFee.find(params[:id])
    if @travel_fee.update(travel_fee_params)
      flash[:notice] = "出張料金を更新しました"
      redirect_to travel_fees_path
    else
      render "edit"
    end
  end

  def destroy
    @travel_fee = TravelFee.find(params[:id])
    if @travel_fee.discard
      flash[:notice] = "出張料金を削除しました"
      redirect_to travel_fees_path
    else
      errors = @travel_fee.errors&.full_messages
      errors.unshift("出張料金を削除できませんでした。")
      flash.now[:errors] = errors

      redirect_to travel_fees_path(@travel_fee)
    end
  end

  private
    def travel_fee_params
      params.require(:travel_fee).permit(:prefecture, :address, :price)
    end

    def search_index(params)
      travel_fees = TravelFee.all
      # 住所あいまい検索
      params[:address]&.gsub(" ", ",")&.gsub("　", ",")&.gsub("、", ",")&.split(",")&.map do |str|
        travel_fees = travel_fees.where("prefecture LIKE ?", "%#{str}%").or(travel_fees.where("address LIKE ?", "%#{str}%"))
      end
      travel_fees = travel_fees.where(price: params[:start_price].strip..) if params[:start_price].present?
      travel_fees = travel_fees.where(price: ..params[:end_price].strip) if params[:end_price].present?
      travel_fees
    end
end
