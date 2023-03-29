class Merchant < ApplicationRecord
  has_many :items
	has_many :invoices

	def self.find_merchant(attribute, keyword)
		where("#{attribute} ILIKE ?", "%#{keyword}%").take
	end
end