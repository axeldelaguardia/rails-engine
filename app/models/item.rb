class Item < ApplicationRecord
  belongs_to :merchant
	validates :name, presence: true, format: { with: /\A[a-zA-Z\s]+\Z/i, message: "only allows letters and white spaces" }
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0, only_float: true, message: "must be a valid float" }
end