class CarWashMenusController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_role_admin!

  def index
    car_wash_menus = CarWashMenu.all
    @car_wash_menus = car_wash_menus.order(created_at:"desc")
  end

  def show
    @car_wash_menu = CarWashMenu.find_by(id: params[:id])
  end

  def new
    @car_wash_menu = CarWashMenu.new
  end

  def create
    @car_wash_menu = CarWashMenu.new(car_wash_menu_params)
    if @car_wash_menu.save
      flash[:notice] = "洗車コースを作成しました。"
      redirect_to car_wash_menus_path
    else
      render "new"
    end
  end

  def edit
    @car_wash_menu = CarWashMenu.find_by(id: params[:id])
  end

  def update
    @car_wash_menu = CarWashMenu.find(params[:id])
    if @car_wash_menu.update(car_wash_menu_params)
      flash[:notice] = "洗車コースを更新しました"
      redirect_to car_wash_menus_path
    else
      render "edit"
    end
  end

  def destroy
    @car_wash_menu = CarWashMenu.find(params[:id])
    @car_wash_menu.check_have_reservation
    if @car_wash_menu.errors.blank? && @car_wash_menu.discard
      flash[:notice] = "洗車コースを削除しました"
      redirect_to car_wash_menus_path
    else
      errors = @car_wash_menu.errors.full_messages
      errors.unshift("洗車コースを削除できませんでした。")
      flash[:errors] = errors
      redirect_to car_wash_menus_path
    end
  end

  private
    def car_wash_menu_params
      params.require(:car_wash_menu)
            .permit(:car_size_id, :name, :price, :required_time, :status, :recommend, :memo, :detail_memo)
    end
end
