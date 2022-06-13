# frozen_string_literal: true

FactoryBot.define do
  factory :car_wash_menu do
    name { "洗車コースA" }
    car_size
    price { 15000 }
    memo { "メモ" }
    detail_memo { "メモ" }
    status { true }
    required_time { 60 }
  end
end
