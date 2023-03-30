FactoryBot.define do
  factory :invoice do
    status { "pending" }
		association :merchant
		association :customer
  end
end
