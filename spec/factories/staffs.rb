# frozen_string_literal: true

FactoryBot.define do
  factory :staff do
    family_name { "テスト" }
    name { "花子" }
    email { "test@gmail.com" }
    password { "hanako@gmail.com" }
    password_confirmation { "hanako@gmail.com" }
    phone { "08011112222" }
    gender { "male" }
    postal_code { "0801111" }
    role { "admin" }
  end
end
