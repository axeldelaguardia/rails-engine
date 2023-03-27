class Item < ApplicationRecord
  belongs_to :merchant
	enum status: [ "enabled", "disabled" ]
end