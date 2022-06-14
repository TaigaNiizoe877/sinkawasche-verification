namespace :notification do
  desc "当日以降の予約内容をslackに通知"
  task reservation_just_to_slack: :environment do
    puts "reservation:just_to_slack... start"
    reservations = Reservation.where("start_at >= ?", Time.zone.now)
    puts "対象件数：#{reservations.count}件"
    if reservations.present?
      reservations.map do |reservation|
        unless reservation.notified_to_slack
          reservation.notification_reservation_just_to_slack
          reservation.notified_to_slack = true
          reservation.save!
        end
      end
    end
    puts "reservation:just_to_slack... end"
  end
end