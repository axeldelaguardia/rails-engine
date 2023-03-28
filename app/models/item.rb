class Item < ApplicationRecord
  belongs_to :merchant
	has_many :invoice_items, dependent: :destroy
	has_many :invoices, through: :invoice_items
	validates :name, presence: true, format: { with: /\A[a-zA-Z\s\,\.]+\Z/i, message: "only allows letters and white spaces" }
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0, only_float: true, message: "must be a valid float" }

	def single_invoices
		invoices.joins(:invoice_items).group(:id).having("COUNT(invoices.id) = 1")
	end
end