class CarWashOptionsController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_role_admin!

  def index
    car_wash_options = CarWashOption.all
    @car_wash_options = car_wash_options.order(created_at:"desc").page(params[:page]).per(5)
  end

  def show
    @car_wash_option = CarWashOption.find_by(id: params[:id])
  end

  def copy
    @car_wash_option = CarWashOption.find_by(id: params[:id]).deep_dup
    render "new"
  end

  def new
    @car_wash_option = CarWashOption.new
  end

  def create
    @car_wash_option = CarWashOption.new(car_wash_option_params)
    if @car_wash_option.save
      flash[:notice] = "洗車オプションを作成しました。"
      redirect_to car_wash_options_path
    else
      render "new"
    end
  end

  def edit
    @car_wash_option = CarWashOption.find_by(id: params[:id])
  end

  def update
    @car_wash_option = CarWashOption.find(params[:id])
    if @car_wash_option.update(car_wash_option_params)
      flash[:notice] = "洗車オプションを更新しました"
      redirect_to car_wash_options_path
    else
      render "edit"
    end
  end

  def destroy
    @car_wash_option = CarWashOption.find(params[:id])
    @car_wash_option.check_have_reservation
    if @car_wash_option.errors.blank? && @car_wash_option.discard
      flash[:notice] = "洗車オプションを削除しました"
      redirect_to car_wash_options_path
    else
      errors = @car_wash_option.errors.full_messages
      errors.unshift("洗車オプションを削除できませんでした。")
      flash[:errors] = errors
      redirect_to car_wash_options_path
    end
  end

  private
    def car_wash_option_params
      params.require(:car_wash_option)
            .permit(:car_size_id, :name, :price, :required_time, :status, :recommend, :memo, :detail_memo)
    end
end
