# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reservation, type: :model, vcr: true do
  let(:working_location) { create(:working_location) }
  let(:reservation) { create(:reservation, id: 100, start_at: Time.parse(Time.current.tomorrow.to_date.to_s + " 9:00 JST"), end_at: Time.parse(Time.current.tomorrow.to_date.to_s + " 10:00 JST"), customer: working_location.customer, working_location: working_location) }

  it { should belong_to(:staff).optional }
  it { should belong_to(:customer) }
  it { should belong_to(:working_location) }
  it { should have_many(:reservation_infos) }

  it { is_expected.to validate_presence_of(:total_price) }
  it { is_expected.to validate_presence_of(:start_at) }
  it { is_expected.to validate_presence_of(:end_at) }

  describe "vacancy calculation" do
    context "シフトがない場合" do
      it "is invalid" do
        StaffShift.delete_all
        Reservation.delete_all
        expect(Reservation.vacancy(Time.now.to_date)).to eql(0)
      end
    end

    context "シフトがある場合" do
      it "予約がない場合" do
        StaffShift.delete_all
        Reservation.delete_all
        staff_shift = create(:staff_shift)
        expect(Reservation.vacancy(Time.now.to_date)).to eql((staff_shift.end_at - staff_shift.start_at) / 60)
      end

      it "予約がある場合" do
        StaffShift.delete_all
        Reservation.delete_all

        staff_shift = create(:staff_shift)
        time = 60
        menu = create(:car_wash_menu, required_time: time)
        option = create(:car_wash_option, required_time: time)
        working_location = create(:working_location)

        new_eservation = Reservation.create({
          id: 100,
          customer_id: working_location.customer.id,
          working_location_id: working_location.id,
          staff_id: staff_shift.staff_id,
          start_at: staff_shift.start_at,
          travel_fee: 0,
          reservation_infos_attributes: [
            reservation_id: 100,
            car_size_id: menu.car_size_id,
            car_wash_menu_id: menu.id,
            car_model_name: "新作アウディ",
            reservation_car_wash_options_attributes: [
              car_wash_option_id: option.id
            ]
          ]
        })
        new_eservation.recalculate_total_price
        new_eservation.save

        reservations_time = time * 2 + staff_shift.staff.buffer_time
        shifts_time = (staff_shift.end_at - staff_shift.start_at) / 60
        expect(Reservation.vacancy(Time.now.to_date)).to eql(shifts_time - reservations_time)
      end
    end
  end

  it { expect(reservation.start_end_at_to_string).to include("09時00分 ~ 10時00分") }
end
