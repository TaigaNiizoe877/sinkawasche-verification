# frozen_string_literal: true

class RequestChange < ApplicationRecord
  include Discard::Model
  belongs_to :reservation

  validates :memo, presence: true
  validates :status, presence: true

  enum status: { read: "read", unread: "unread" }
  enum reservation_type: { change: "change", cancel: "cancel" }
end
