# frozen_string_literal: true

require "rails_helper"

RSpec.describe TravelFee, type: :model do
  let(:travel_fee_1) { create(:travel_fee, prefecture: "福岡県", address: "中央区", price: 1000) }
  let(:travel_fee_2) { create(:travel_fee, prefecture: "福岡県", address: "中央区天神", price: 10000) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:prefecture) }
  it { is_expected.to validate_presence_of(:address) }
  it { should validate_uniqueness_of(:address).ignoring_case_sensitivity }
  it {
    travel_fee_1
    travel_fee_2
    expect(TravelFee.search_travel_fees("福岡県", "中央区天神").price).to eq(10000)
  }
end
