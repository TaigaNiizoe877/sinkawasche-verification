# frozen_string_literal: true

StaffShift.delete_all

staffs = Staff.role_staff
staffs[0..2].each do |staff|
  (DateTime.now.beginning_of_month..(DateTime.now + 2.months).end_of_month).map(&:to_date).map(&:to_s).each do |day|
    StaffShift.find_or_create_by(
        staff_id: staff.id,
        start_at: Time.parse(day + " 9:00:00"),
        end_at: Time.parse(day + " 16:00:00"),
      )
  end
end

staffs[3..5].each do |staff|
  (DateTime.now.beginning_of_month..(DateTime.now.beginning_of_month + 15.days)).map(&:to_date).map(&:to_s).each do |day|
    StaffShift.find_or_create_by(
        staff_id: staff.id,
        start_at: Time.parse(day + " 9:00:00"),
        end_at: Time.parse(day + " 16:00:00"),
      )
  end
end
