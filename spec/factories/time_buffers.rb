# frozen_string_literal: true

FactoryBot.define do
  factory :time_buffer do
    staff
    time { "11:12" }
  end
end
