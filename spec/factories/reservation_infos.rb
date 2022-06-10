# frozen_string_literal: true

FactoryBot.define do
  factory :reservation_info do
    reservation
    car_size
    car_wash_menu
    car_model_name { "ラパン" }
  end
end
