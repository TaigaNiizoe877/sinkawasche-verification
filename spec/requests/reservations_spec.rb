# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reservations", type: :request do
  let!(:staff) { create(:staff) }
  let!(:customer) { create(:customer) }
  let!(:car_size) { create(:car_size) }
  let!(:working_location) { create(:working_location, customer: customer) }
  let!(:car_wash_menu) { create(:car_wash_menu, car_size: car_size) }
  let!(:car_wash_option) { create(:car_wash_option, car_size: car_size) }
  let!(:travel_fee) { create(:travel_fee) }
  let!(:reservation) { create(:reservation, staff: staff, customer: customer, working_location: working_location, travel_fee: travel_fee) }
  let!(:reservation_info) { create(:reservation_info, reservation: reservation, car_size: car_size, car_wash_menu: car_wash_menu) }
  let!(:reservation_car_wash_option) { create(:reservation_car_wash_option, reservation_info: reservation_info, car_wash_option: car_wash_option) }

  before do
    sign_in staff
  end

  describe "GET #index" do
    it "一覧にアクセスできること" do
      get reservations_path
      expect(response.body).to be_include("予約一覧")
    end
  end

  describe "GET #show" do
    it "詳細にアクセスできること" do
      get reservation_path(reservation)
      expect(response.body).to be_include("予約詳細")
    end
  end

  describe "GET #new" do
    it "新規作成にアクセスできること" do
      get new_reservation_path
      expect(response.body).to be_include("予約新規作成")
    end
  end

  describe "POST #new" do
    let(:create_params) { {
      reservation: { customer_id: customer.id, staff_id: staff.id, working_location_id: working_location.id, start_at: Time.now, end_at: Time.now, status: "approval", auto_culc_flag: true, memo: "memo", reservation_infos_attributes: { "0": { car_size_id: car_size.id, car_wash_menu_id: car_wash_menu.id, car_model_name: "ラパン", reservation_car_wash_options_attributes: { "0": { car_wash_option_id: car_wash_option.id, _destroy: "0" } } } } } } }
    it "新規作成が成功すること" do
      expect(Reservation.all.count).to(eq(1))
      expect(Reservation.last.status).to(eq("applying"))
      post reservations_path, params: create_params
      expect(Reservation.all.count).to(eq(2))
      expect(Reservation.last.status).to(eq("approval"))
      result = Reservation.last
      expect(result[:total_price]).to eq(19000)
      expect(response).to redirect_to(reservation_path(result))
      expect(flash[:notice]).to match("予約を作成しました")
    end
  end

  describe "GET #edit" do
    it "編集にアクセスできること" do
      get edit_reservation_path(reservation)
      expect(response.body).to be_include("予約編集")
    end
  end

  describe "PATCH #update" do
    let(:car_size_1) { create(:car_size, name: "L", memo: "memo") }
    let(:car_wash_menu_1) { create(:car_wash_menu, name: "コースB", car_size: car_size_1, price: 12000) }
    let(:car_wash_option_1) { create(:car_wash_option, name: "車内清掃", car_size: car_size_1, price: 3000) }
    let(:update_params) { {
      reservation: { status: "approval", auto_culc_flag: true, memo: "memo", reservation_infos_attributes: { "0": { id: reservation_info.id, car_size_id: car_size_1.id, car_wash_menu_id: car_wash_menu_1.id, car_model_name: "アイリス", reservation_car_wash_options_attributes: { "0": { id: reservation_car_wash_option.id, car_wash_option_id: car_wash_option.id, _destroy: "1" }, "1": { id: "", car_wash_option_id: car_wash_option_1.id, _destroy: "0" } } } } } } }
    it "編集更新が成功すること" do
      expect do
        patch reservation_path(reservation), params: update_params
      end.to change {
        reservation.reload.status
      }.from(reservation.status).to("approval")
      result = Reservation.find_by(id: reservation.id)
      expect(result[:total_price]).to eq(15000)
      expect(response).to redirect_to(reservation_path(result))
      expect(flash[:notice]).to match("予約を更新しました")
    end
  end
end
