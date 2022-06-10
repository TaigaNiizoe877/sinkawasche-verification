# frozen_string_literal: true

FactoryBot.define do
  factory :working_location do
    customer
    postal_code { "8100001" }
    prefecture { "福岡県" }
    address_first { "福岡市中央区天神" }
    address_second { "１丁目８−１" }
    building { "２Ｆ" }
  end
end
