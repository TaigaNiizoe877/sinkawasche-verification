# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    family_name { "テスト" }
    name { "太郎" }
    family_name_kana { "テスト" }
    name_kana { "タロウ" }
    email { "taro@example.com" }
    password { "taro@example.com" }
    phone { "08011112222" }
    postal_code { "1111111" }
    prefecture { "a" }
    address_first { "b" }
    address_second { "c" }
    building { "d" }
    memo { "memo" }
    aware_route { "flyer" }
    latitude { "1" }
    longitude { "1" }
    notice { true }
  end
end
