# frozen_string_literal: true

require "rails_helper"

RSpec.describe CarSize, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:memo) }
  it { should have_one(:reservation_info) }
  it { should have_many(:car_wash_menus) }
  it { should have_many(:car_wash_options) }

  describe "#validate_on_destroy" do
    let(:car_size) { create(:car_size) }

    context "洗車メニュー、オプションと紐づいていない場合" do
      it "削除できること" do
        expect(car_size.discarded_at).to eq(nil)
        car_size.discard
        expect(car_size.discarded_at).not_to eq(nil)
      end
    end

    # context '洗車メニュー、オプションと紐づいている場合' do
    #   before do
    #     create(:car_wash_menu, car_size: car_size)
    #     create(:car_wash_option, car_size: car_size)
    #   end

    #   it '削除できないこと' do
    #     expect(car_size.discarded_at).to eq(nil)
    #     expect { car_size.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
    #     expect(car_size.discarded_at).to eq(nil)
    #   end
    # end
  end
end
