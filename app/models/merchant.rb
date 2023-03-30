class Merchant < ApplicationRecord
  has_many :items
	has_many :invoices

	def self.find_merchant(keyword)
		where("name ILIKE ?", "%#{keyword}%").take
	end
end