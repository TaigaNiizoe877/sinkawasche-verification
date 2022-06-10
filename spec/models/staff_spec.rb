# frozen_string_literal: true

require "rails_helper"

RSpec.describe Staff, type: :model, vcr: true do
  let(:staff) { create(:staff, family_name: "茂野", name: "吾郎", prefecture: "福岡県", address: "福岡市中央区天神") }
  it { should have_many(:reservations) }
  it { should have_many(:staff_shifts) }
  it { is_expected.to validate_presence_of(:family_name) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to validate_presence_of(:gender).on(:update) }
  it { is_expected.to validate_presence_of(:phone).on(:update) }
  it { is_expected.to validate_presence_of(:postal_code).on(:update) }
  it { should validate_uniqueness_of(:phone).ignoring_case_sensitivity.on(:update) }
  it { expect(staff.full_address).to eq("福岡県 福岡市中央区天神") }
  it { expect(staff.full_name).to eq("茂野 吾郎") }

  describe "valid check_have_reservation" do
    context "予約が入っている場合" do
      it "errorを追加" do
        staff_1 = create(:staff, role: "staff", family_name: "田中", name: "武", email: "staff_1@gmail.com")
        StaffShift.create(
          staff: staff_1,
          start_at: Time.parse(Time.current.to_date.to_s + " 9:00 JST"),
          end_at: Time.parse(Time.current.to_date.to_s + " 17:00 JST")
        )
        create(:reservation, start_at: Time.current, staff: staff_1)
        staff_1.check_have_reservation
        expect(staff_1.errors.full_messages).to include("予約に紐づいているため、削除できません")
      end
    end
  end

  describe "valid format" do
    context "フォーマットが正確の場合は、有効であること" do
      it "is valid" do
        staff.email = "test@gmail.com"
        staff.phone = "08000001111"
        staff.postal_code = "8900054"
        expect(staff).to be_valid
      end
    end

    context "フォーマットが不正確の場合は、無効であること" do
      it "is invalid" do
        staff.email = "test@"
        staff.phone = "080-0000-1111"
        staff.postal_code = "890-0054"
        expect(staff).to be_invalid
        expect(staff.errors[:email]).to include("は不正な値です")
        expect(staff.errors[:phone]).to include("-(ハイフン)は入れないでください")
        expect(staff.errors[:postal_code]).to include("-(ハイフン)は入れないでください")

        staff.phone = "080000011112"
        staff.postal_code = "89000009"
        expect(staff).to be_invalid
        expect(staff.errors[:phone]).to include("10または11桁にしてください")
        expect(staff.errors[:postal_code]).to include("7桁にしてください")
      end
    end
  end


  describe "when: available" do
    context "selfが管理者の場合" do
      it "nilを返す" do
        staff_1 = create(:staff, role: "admin", family_name: "田中", name: "武", email: "staff_1@gmail.com")
        expect(staff_1.available(Time.current, 120, "8900000")).to eq(nil)
      end
    end

    context "シフトが存在していない場合" do
      it "nilを返す" do
        staff_1 = create(:staff, role: "staff", family_name: "田中", name: "武", email: "staff_1@gmail.com")
        expect(staff_1.available(Time.current, 120, "8900000")).to eq(nil)
      end
    end

    context "時間が被る予約がある場合" do
      it "nilを返す" do
        customer = create(:customer)
        staff_1 = create(:staff, role: "staff", family_name: "田中", name: "武", email: "staff_1@gmail.com")
        StaffShift.create(
          staff: staff_1,
          start_at: Time.parse(Time.current.to_date.to_s + " 9:00 JST"),
          end_at: Time.parse(Time.current.to_date.to_s + " 17:00 JST")
        )
        menu = create(:car_wash_menu)
        car_size = menu.car_size
        option = create(:car_wash_option, car_size: car_size)
        reservation = build(:reservation, start_at: Time.current, customer: customer, staff: staff_1)
        reservation.assign_attributes(
          reservation_infos_attributes: [
            { car_wash_menu: menu, car_model_name: "カローラ", car_size: car_size, car_wash_options: [option] }
          ]
        )
        reservation.save
        expect(staff_1.available(Time.current, 120, "8900000")).to eq(nil)
      end
    end

    context "直前に予約があるが、予約が可能な場合" do
      it "オブジェクトを返す" do
        customer = create(:customer)
        working_location = create(:working_location, postal_code: "8100001", customer: customer)
        staff_1 = create(:staff, role: "staff", family_name: "田中", name: "武", email: "staff_1@gmail.com")
        StaffShift.create(
          staff: staff_1,
          start_at: Time.parse(Time.current.to_date.to_s + " 9:00 JST"),
          end_at: Time.parse(Time.current.to_date.to_s + " 17:00 JST")
        )
        menu = create(:car_wash_menu)
        car_size = menu.car_size
        option = create(:car_wash_option, car_size: car_size)
        reservation = build(:reservation, start_at: Time.parse(Time.current.to_date.to_s + " 9:00 JST"), end_at: Time.parse(Time.current.to_date.to_s + " 11:00 JST"), customer: customer, staff: staff_1, working_location: working_location)
        reservation.assign_attributes(
          reservation_infos_attributes: [
            { car_wash_menu: menu, car_model_name: "カローラ", car_size: car_size, car_wash_options: [option] }
          ]
        )
        reservation.save
        expect(staff_1.available(Time.parse(Time.current.to_date.to_s + " 13:00 JST"), 120, "8100001").full_name).to eq("田中 武")
      end
    end

    context "直後に予約があるが、予約が可能な場合" do
      it "オブジェクトを返す" do
        customer = create(:customer)
        working_location = create(:working_location, postal_code: "8100001", customer: customer)
        staff_1 = create(:staff, role: "staff", family_name: "田中", name: "武", email: "staff_1@gmail.com")
        StaffShift.create(
          staff: staff_1,
          start_at: Time.parse(Time.current.to_date.to_s + " 9:00 JST"),
          end_at: Time.parse(Time.current.to_date.to_s + " 17:00 JST")
        )
        menu = create(:car_wash_menu)
        car_size = menu.car_size
        option = create(:car_wash_option, car_size: car_size)
        reservation = build(:reservation, start_at: Time.parse(Time.current.to_date.to_s + " 15:00 JST"), end_at: Time.parse(Time.current.to_date.to_s + " 17:00 JST"), customer: customer, staff: staff_1, working_location: working_location)
        reservation.assign_attributes(
          reservation_infos_attributes: [
            { car_wash_menu: menu, car_model_name: "カローラ", car_size: car_size, car_wash_options: [option] }
          ]
        )
        reservation.save
        expect(staff_1.available(Time.parse(Time.current.to_date.to_s + " 9:00 JST"), 120, "8100001").full_name).to eq("田中 武")
      end
    end
  end

  describe "when: self.active_staff_on_date" do
    context "シフトが存在している場合" do
      it "オブジェクトの配列を返す" do
        staffs = []
        staffs << create(:staff, role: "staff", family_name: "田中", name: "武", email: "staff_1@gmail.com")
        staffs << create(:staff, role: "staff", family_name: "田中", name: "太郎", email: "staff_2@gmail.com")
        staffs.each do |staff|
          StaffShift.create(
            staff: staff,
            start_at: Time.parse(Time.current.to_date.to_s + " 9:00 JST"),
            end_at: Time.parse(Time.current.to_date.to_s + " 17:00 JST")
          )
        end
        staffs.each do |staff|
          expect(Staff.active_staff_on_date(Time.current.to_date).where(id: staff.id).count).to eq(1)
        end
      end
    end

    context "シフトが存在していない場合" do
      it "空配列のオブジェクトを返す" do
        expect(Staff.active_staff_on_date(Time.current.to_date).count).to eq(0)
      end
    end
  end
end
