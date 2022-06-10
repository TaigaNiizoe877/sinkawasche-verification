# frozen_string_literal: true

FactoryBot.define do
  factory :staff_shift do
    staff
    start_at { Time.current.beginning_of_day + 9.hours }
    end_at { start_at + 9.hours }
  end
end
