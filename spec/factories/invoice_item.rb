FactoryBot.define do
  factory :invoice_item do
    quantity {Faker::Number.number(digits: 2)}
    unit_price {Faker::Number.number(digits: 2)}
		association :item
		association :invoice
  end
end
