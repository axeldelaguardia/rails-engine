class Merchant < ApplicationRecord
  has_many :items

	scope :active_merchants, -> { where(status: 1) }
	scope :disabled_merchants, -> { where(status: 0) }
end