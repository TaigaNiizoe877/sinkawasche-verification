# frozen_string_literal: true

# Reservation.delete_all

# customer = Customer.first
# res = []

# 10.times.each do |i|
#   menu = CarWashMenu.all.to_a[i].presence || CarWashMenu.last
#   option_1 = CarWashOption.where(car_size_id: menu.car_size_id).to_a[i].presence || CarWashOption.where(car_size_id: menu.car_size_id).last
#   option_2 = CarWashOption.where(car_size_id: menu.car_size_id).to_a[i + 1].presence || CarWashOption.where.not(car_size_id: option_1.id).where(car_size_id: menu.car_size_id).last
#   model_name = CarModel.all.to_a[i]&.name.presence || CarModel.last.name

#   start_at = StaffShift.first.start_at + (i * 3).days
#   end_at = start_at + 1.hours

#   res = Reservation.new(
#     {
#       staff_id: StaffShift.first.staff.id,
#       customer_id: customer.id,
#       start_at: start_at,
#       end_at: end_at,
#       memo: "メモ",
#       sent_email: true,
#       reservation_infos_attributes: [
#         {
#           car_size_id: menu.car_size_id,
#           car_model_name: model_name,
#           car_wash_menu_id: menu.id,
#           reservation_car_wash_options_attributes: [
#             { car_wash_option_id: option_1.id },
#             { car_wash_option_id: option_2.id }
#           ]
#         }
#       ]
#     }
#   )
#   res.recalculate_total_price
#   res.save
# end
