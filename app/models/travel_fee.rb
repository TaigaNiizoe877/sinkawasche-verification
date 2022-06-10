# frozen_string_literal: true

class TravelFee < ApplicationRecord
  include Discard::Model

  validates :price, presence: true
  validates :prefecture, presence: true
  validates :address, presence: true
  validates_uniqueness_of :address, conditions: -> { where(discarded_at: nil) }

  def self.search_travel_fees(prefecture, address)
    t_fees = TravelFee.where(prefecture: prefecture).sort_by { |x| x.address.size }.reverse
    t_fees.map do |t_fee|
      return t_fee if address.start_with?(t_fee.address)
    end.first
  end
end
