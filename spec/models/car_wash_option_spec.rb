# frozen_string_literal: true

require "rails_helper"

RSpec.describe CarWashOption, type: :model do
  let(:price) { 1000 }
  let(:option) { create(:car_wash_option, price: price) }
  let(:option_to_be_valid) { create(:car_wash_option) }
  let(:reservation_info) { create(:reservation_info, car_wash_options: [option_to_be_valid]) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:required_time) }
  it { should have_many(:reservation_infos) }
  it { should belong_to(:car_size) }
  it { expect(option.price_jpy).to eq("¥#{price.to_fs(:delimited)}") }

  describe '#validate_to_have_reservation' do

    context '予約と紐づいていない場合' do
      it '削除可否の検証がエラーが発生しないこと' do
        expect(option.discarded_at).to eq(nil)
        option.check_have_reservation
        option.errors.blank? && option.discard
        expect(option.discarded_at).not_to eq(nil)
      end
    end

    context '予約と紐づいている場合', vcr: true do
      it '削除可否の検証がエラーが発生すること' do
        expect(option_to_be_valid.discarded_at).to eq(nil)
        reservation_info
        option_to_be_valid.check_have_reservation
        option_to_be_valid.errors.blank? && option_to_be_valid.discard
        expect(option_to_be_valid.discarded_at).to eq(nil)
      end
    end
  end
end