# frozen_string_literal: true

require "rails_helper"

RSpec.describe CarWashMenu, type: :model, vcr: true do
  let(:price) { 1000 }
  let(:menu) { create(:car_wash_menu, price: price) }
  let(:menu_to_be_valid) { create(:car_wash_menu) }
  let(:reservation_info) { create(:reservation_info, car_wash_menu: menu_to_be_valid) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:required_time) }
  it { should have_many(:reservation_infos) }
  it { should belong_to(:car_size) }
  it { expect(menu.price_jpy).to eq("¥#{price.to_fs(:delimited)}") }

  describe '#validate_to_have_reservation' do
    context '予約と紐づいていない場合' do
      it '削除可否の検証がエラーが発生しないこと' do
        expect(menu.discarded_at).to eq(nil)
        menu.check_have_reservation
        menu.errors.blank? && menu.discard
        expect(menu.discarded_at).not_to eq(nil)
      end
    end

    context '予約と紐づいている場合' do
      it '削除可否の検証がエラーが発生すること' do
        expect(menu_to_be_valid.discarded_at).to eq(nil)
        reservation_info
        menu_to_be_valid.check_have_reservation
        menu_to_be_valid.errors.blank? && @car_wash_menu.discard
        expect(menu_to_be_valid.discarded_at).to eq(nil)
      end
    end
  end
end
