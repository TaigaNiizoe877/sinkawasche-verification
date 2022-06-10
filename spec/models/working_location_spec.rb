# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorkingLocation, type: :model, vcr: true do
  let(:working_location) { create(:working_location, prefecture: "福岡県", address_first: "福岡市中央区天神", address_second: "1-10", building: "hogeビル") }
  it { should belong_to(:customer) }
  it { should have_many(:reservations) }
  it { is_expected.to validate_presence_of(:prefecture) }
  it { is_expected.to validate_presence_of(:address_first) }
  it { is_expected.to validate_presence_of(:address_second) }
  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to validate_presence_of(:postal_code) }
  it { expect(working_location.full_address).to eq("福岡県福岡市中央区天神1-10(hogeビル)") }

  describe "valid check_have_reservation" do
    context "予約が入っている場合" do
      it "errorを追加" do
        create(:reservation, working_location: working_location)
        working_location.check_have_reservation
        expect(working_location.errors.full_messages).to include("予約に紐づいているため、削除できません")
      end
    end
  end

  describe "valid format" do
    context "フォーマットが正確の場合は、有効であること" do
      it "is valid" do
        expect(working_location).to be_valid
      end
    end

    context "フォーマットが不正確の場合は、無効であること" do
      it "is invalid" do
        working_location.postal_code = "890-0054"
        expect(working_location).to be_invalid
        expect(working_location.errors[:postal_code]).to include("-(ハイフン)は入れないでください")

        working_location.postal_code = "89000009"
        expect(working_location).to be_invalid
        expect(working_location.errors[:postal_code]).to include("7桁にしてください")
      end
    end
  end
end
