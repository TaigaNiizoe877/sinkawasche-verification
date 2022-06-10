# frozen_string_literal: true

module StaffShiftsHelper
  def shape_data(data)
    string = ""
    data.to_a.map do |key, value|
      string += "#{key}=>#{value[:start_at]},#{value[:end_at]}/"
    end
    string
  end
end
