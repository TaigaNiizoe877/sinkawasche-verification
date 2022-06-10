# frozen_string_literal: true

Customer.delete_all
Staff.delete_all
# ユーザ
customer_attributes = [
  { family_name: "田中", name: "太郎", family_name_kana: "タナカ", name_kana: "タロウ", email: "tarou@gmail.com", password: "tarou@gmail.com", phone: "07000000000", postal_code: "8100000", prefecture: "福岡県", address_first: "福岡市中央区", address_second: "1-3", building: "天神ビル 1F", memo: "メモ", aware_route: "flyer", notice: true },
  { family_name: "亀田", name: "鶴太郎", family_name_kana: "カメダ", name_kana: "ツルタロウ", email: "turutarou@gmail.com", password: "turutarou@gmail.com", phone: "07000000001", postal_code: "8100000", prefecture: "福岡県", address_first: "福岡市中央区", address_second: "1-3", building: "天神ビル 1F", memo: "メモ", aware_route: "flyer", notice: true },
  { family_name: "聖", name: "星矢", family_name_kana: "ヒジリ", name_kana: "セイヤ", email: "seiya@gmail.com", password: "seiya@gmail.com", phone: "07000000002", postal_code: "8100000", prefecture: "福岡県", address_first: "福岡市中央区", address_second: "1-3", building: "天神ビル 1F", memo: "メモ", aware_route: "flyer", notice: true },
  { family_name: "児玉", name: "清", family_name_kana: "コダマ", name_kana: "キヨシ", email: "kiyoshi@gmail.com", password: "kiyoshi@gmail.com", phone: "07000000003", postal_code: "8100000", prefecture: "福岡県", address_first: "福岡市中央区", address_second: "1-3", building: "天神ビル 1F", memo: "メモ", aware_route: "flyer", notice: true }
]
customer_attributes.map do |attribute|
  next if Customer.find_by(email: attribute[:email]).present?
  customer = Customer.create(
    family_name: attribute[:family_name],
    name: attribute[:name],
    family_name_kana: attribute[:family_name_kana],
    name_kana: attribute[:name_kana],
    email: attribute[:email],
    password: attribute[:password],
    phone: attribute[:phone],
    postal_code: attribute[:postal_code],
    prefecture: attribute[:prefecture],
    address_first: attribute[:address_first],
    address_second: attribute[:address_second],
    building: attribute[:building],
    memo: attribute[:memo],
    aware_route: attribute[:aware_route],
    notice: attribute[:notice]
  )

  WorkingLocation.create(
    customer: customer,
    postal_code: customer.postal_code,
    prefecture: customer.prefecture,
    address_first: customer.address_first,
    address_second: customer.address_second,
    building: customer.building
  )
end

count = 0
[["さくら", "花子", "hanako", "admin"], ["東", "大三郎", "saburou", "staff"], ["時吉", "雄大", "yudai", "staff"], ["桑原", "龍樹", "tatsuki", "staff"], ["桑原", "大樹", "hiroki", "staff"], ["荻原", "健", "ken", "staff"]].map do |family_name, name, email, role|
  next if Staff.find_by(name: family_name)
  count += 1
  Staff.create(
      family_name: family_name,
      name: name,
      role: role,
      email: "#{email}@gmail.com",
      gender: "not_set",
      password: "#{email}@gmail.com",
      password_confirmation: "#{email}@gmail.com",
      phone: "0700000000#{count}",
      postal_code: "8910000",
      prefecture: "鹿児島県",
      address: "鹿児島市下荒田"
    )
end
