# frozen_string_literal: true

class ReservationCarWashOption < ApplicationRecord
  include Discard::Model

  belongs_to :reservation_info
  belongs_to :car_wash_option
end