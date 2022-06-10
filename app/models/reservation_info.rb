# frozen_string_literal: true

class ReservationInfo < ApplicationRecord
  include Discard::Model
  belongs_to :reservation
  belongs_to :car_size

  accepts_nested_attributes_for :reservation_car_wash_options, allow_destroy: true

  validates :car_model_name, presence: true
end
