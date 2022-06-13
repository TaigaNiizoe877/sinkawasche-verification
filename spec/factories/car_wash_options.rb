# frozen_string_literal: true

FactoryBot.define do
  factory :car_wash_option do
    name { "ホイール洗車" }
    # ↑一般的な記法。nameカラムに「ホイール洗車」を入れてねということ
    car_size
    price { 4000 }
    memo { "メモ" }
    detail_memo { "メモ" }
    status { true }
    required_time { 60 }
  end
end