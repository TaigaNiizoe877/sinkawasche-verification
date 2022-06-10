# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReservationCarWashOption, type: :model do
  it { should belong_to(:reservation_info) }
  it { should belong_to(:car_wash_option) }
end
