# frozen_string_literal: true

FactoryBot.define do
  factory :reservation_car_wash_option do
    reservation_info
    car_wash_option
  end
end
