# frozen_string_literal: true

module Request
  module RequestGeo
    require "json"
    require "net/https"
    require "uri"

    def get_geo(postal_code)
      { lon: 139, lat: 39 }
      #  if Rails.env.development?

      # pl = PostalLocation.find_by(postal_code: postal_code)
      # if pl.present?
      #   result = {lon: pl.longitude, lat: pl.latitude}
      # else
      #   query = {
      #     address: postal_code,
      #     key: ENV['GEOCODING_API_KEY']
      #   }
      #   query = query.to_query
      #   uri = URI("https://maps.googleapis.com/maps/api/geocode/json?language=ja&components=country:JP&" + query)
      #   http = Net::HTTP.new(uri.host, uri.port)
      #   http.use_ssl = true
      #   req = Net::HTTP::Get.new(uri)
      #   res = http.request(req)
      #   res_data = JSON.parse(res.body)
      #   # DBに同じpostal_codeがある場合は流用する
      #   location = res_data["results"][0]["geometry"]["location"]
      #   result = {
      #     lon: location["lng"],
      #     lat: location["lat"]
      #   }
      #   PostalLocation.find_or_create_by(
      #     postal_code: postal_code,
      #     longitude: location["lng"],
      #     latitude: location["lat"]
      #   )
      # end

      # result
    end

    def travel_time(start_postal_code, end_postal_code)
      30
      #  if Rails.env.development?

      # start_place = get_location_as_string(start_postal_code)
      # end_place = get_location_as_string(end_postal_code)
      # tt = TravelTimeHistory.find_by(start_postal_code: start_postal_code, end_postal_code: end_postal_code)
      # if tt.present?
      #   travel_time = tt.travel_time
      # else
      #   query = {
      #     key: ENV['DURATION_API_KEY'],
      #     origin: start_place, #緯度, 経度
      #     destination: end_place, #緯度, 経度
      #     mode: "driving",
      #     avoid: "tolls" # 回避: 有料道路
      #   }
      #   query = query.to_query
      #   uri = URI("https://maps.googleapis.com/maps/api/directions/json?language=ja&" + query)
      #   http = Net::HTTP.new(uri.host, uri.port)
      #   http.use_ssl = true
      #   req = Net::HTTP::Get.new(uri)
      #   res = http.request(req)
      #   res_data = JSON.parse(res.body)
      #   duration_minutes = res_data.dig("routes")&.first.dig("legs")&.first.dig("duration", "value") / 60
      #   duration_minutes

      #   TravelTimeHistory.create(
      #     start_postal_code: start_postal_code,
      #     end_postal_code: end_postal_code,
      #     travel_time: duration_minutes
      #   )
      #   travel_time = duration_minutes
      # end

      # travel_time
    end

    # def get_location_as_string(postal_code)
    #   lat, lon = get_geo(postal_code).values
    #   lon.to_s + "," +  lat.to_s
    # end
  end
end
