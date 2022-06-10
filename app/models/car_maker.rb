# frozen_string_literal: true

class CarMaker < ApplicationRecord
  include Discard::Model

  has_many :car_models

  validates :name, presence: true
end
