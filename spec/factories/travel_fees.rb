# frozen_string_literal: true

FactoryBot.define do
  factory :travel_fee do
    price { 1000 }
    prefecture { "福岡県" }
    address { "中央区" }
  end
end
