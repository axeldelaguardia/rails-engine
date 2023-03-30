class Item < ApplicationRecord
	belongs_to :merchant
	has_many :invoice_items, dependent: :destroy
	has_many :invoices, through: :invoice_items
	validates :name, presence: true, format: { with: /\A[a-zA-Z\s\,\.]+\Z/i, message: "only allows letters and white spaces" }
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0, only_float: true, message: "must be a valid float" }

	def single_invoices
		invoices.joins(:invoice_items)
						.group(:id)
						.having("COUNT(invoices.id) = 1")
	end

	def self.find_by_name(keyword)
		where("name ILIKE ?", "%#{keyword}%")
	end

	def self.find_by_price(hash)
		if hash[:min_price] && hash[:max_price]
			where("unit_price >= ? AND unit_price <= ?", hash[:min_price], hash[:max_price])
		elsif hash[:min_price]
			where("unit_price >= ?", hash[:min_price])
		else
			where("unit_price <= ?", hash[:max_price])
		end
	end
end