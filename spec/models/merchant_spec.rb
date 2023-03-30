require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

	describe "::find_merchant" do
		it "finds merchant by keyword" do
			merchant_1 = create(:merchant, name: "Red Star")
			merchant_2 = create(:merchant)

			found_merchant = Merchant.find_merchant("red")
			expect(found_merchant).to eq(merchant_1)
			expect(found_merchant).to_not eq(merchant_2)
		end

		it "returns nil if no merchants found" do
			merchant_1 = create(:merchant, name: "Red Star")
			merchant_2 = create(:merchant)

			found_merchant = Merchant.find_merchant("green")

			expect(found_merchant).to eq(nil)
		end
	end
end