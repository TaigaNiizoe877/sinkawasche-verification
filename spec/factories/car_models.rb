# frozen_string_literal: true

FactoryBot.define do
  factory :car_model do
    car_maker
    name { "テスト" }
  end
end
