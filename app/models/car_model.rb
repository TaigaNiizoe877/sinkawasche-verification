# frozen_string_literal: true

class CarModel < ApplicationRecord
  include Discard::Model

  belongs_to :car_maker

  validates :name, presence: true
end
