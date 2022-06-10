# frozen_string_literal: true

TravelFee.delete_all

free_list = ["福岡市中央区", "福岡市博多区", "福岡市東区", "福岡市南区", "福岡市城南区", "福岡市早良区", "福岡市西区"]
additional_list = ["糟屋郡志免町", "春日市", "那珂川市", "大野城市"]

free_list.map { |address| [0, "福岡県", address] }.map do |price, prefecture, address|
  TravelFee.find_or_create_by(
    price: price,
    prefecture: prefecture,
    address: address
  )
end

additional_list.map { |address| [1000, "福岡県", address] }.map do |price, prefecture, address|
  TravelFee.find_or_create_by(
    price: price,
    prefecture: prefecture,
    address: address
  )
end
