# frozen_string_literal: true

require "rails_helper"

RSpec.describe StaffShift, type: :model do
  let(:staff_shift) { build(:staff_shift, start_at: Time.current, end_at: Time.current + 1.hours) }
  let(:past_staff_shift) { build(:staff_shift, start_at: Time.current - 3.day, end_at: Time.current - 3.day + 1.hours) }
  let(:reservation) { build(:reservation, start_at: Time.current - 3.day, end_at: Time.current - 3.day + 1.hours) }

  it { should belong_to(:staff) }

  it { is_expected.to validate_presence_of(:start_at) }
  it { is_expected.to validate_presence_of(:end_at) }

  describe "日付のpastチェック" do
    context "今日以降の日付の時" do
      it "is valid" do
        expect(staff_shift).to be_valid
        expect(staff_shift.errors[:base]).to eql([])
      end
    end

    context "過去の日付の時" do
      it "is invalid" do
        past_staff_shift.save
        expect(past_staff_shift.errors[:base].first).to include("過去のシフトは変更できません。")
      end
    end
  end

  describe "予約がある場合変更ができないか" do
    context "予約がある場合" do
      it "is valid" do
        expect(staff_shift).to be_valid
        expect(staff_shift.errors[:base]).to eql([])
      end
    end

    context "予約がない場合", vcr: true do
      it "is invalid" do
        staff_shift = create(:staff_shift, start_at: Time.current.tomorrow + 1.hours, end_at: Time.current.tomorrow + 1.hours)
        staff_shift.update(start_at: Time.current.tomorrow + 2.hours, end_at: Time.current.tomorrow + 3.hours)
        expect(staff_shift.errors[:base].first).to include("予約にアサインされているため、シフトを変更できません。")
      end
    end
  end
end
