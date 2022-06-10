# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReservationInfo, type: :model do
  it { should belong_to(:reservation) }
  it { should belong_to(:car_wash_menu) }
  it { should belong_to(:car_size) }
  it { should have_many(:reservation_car_wash_options) }
  it { should have_many(:car_wash_options) }
  it { is_expected.to validate_presence_of(:car_model_name) }
end
