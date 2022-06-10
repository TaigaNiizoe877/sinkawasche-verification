# frozen_string_literal: true

class WorkingLocationsController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_role_admin!

  def new
    @working_location = WorkingLocation.new
    @customer_id = params[:customer_id]
  end

  def create
    @working_location = WorkingLocation.new(working_location_params)
    if @working_location.save
      flash[:notice] = "作業場所を作成しました。"
      redirect_to customer_path(@working_location.customer_id)
    else
      @customer_id = @working_location.customer_id
      render "new"
    end
  end

  def edit
    @working_location = WorkingLocation.find_by(id: params[:id])
    @customer_id = params[:customer_id]
  end

  def update
    @working_location = WorkingLocation.find(params[:id])
    if @working_location.update(working_location_params)
      flash[:notice] = "作業場所を更新しました。"
      redirect_to customer_path(@working_location.customer_id)
    else
      @customer_id = @working_location.customer_id
      render "edit"
    end
  end

  def destroy
    @working_location = WorkingLocation.find(params[:id])
    @working_location.check_have_reservation
    if @working_location.errors.blank? && @working_location.discard
      notice = "作業場所を削除しました。"
    else
      errors = @working_location.errors&.full_messages
      errors.unshift("作業場所を削除できませんでした。")
    end
    redirect_to customer_path(@working_location.customer_id), flash: { errors: errors, notice: notice }, status: :see_other
  end

  private
    def working_location_params
      params.require(:working_location)
      .permit(:customer_id, :postal_code, :prefecture, :address_first, :address_second, :building)
    end
end
