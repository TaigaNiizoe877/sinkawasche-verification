# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    working_location
    customer { working_location.customer }
    start_at { Time.current.beginning_of_day + 9.hours }
    status { "applying" }
    auto_culc_flag { true }
    total_price { 12000 }
    memo { "メモ" }
  end
end
