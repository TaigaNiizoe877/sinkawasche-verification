# frozen_string_literal: true

FactoryBot.define do
  factory :car_model do
    car_maker
    name { "ใในใ" }
  end
end
