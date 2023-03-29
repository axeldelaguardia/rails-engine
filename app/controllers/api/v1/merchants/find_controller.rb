class Api::V1::Merchants::FindController < ApplicationController
	def show
		key = params.keys.select { |key| key != "controller" && key != "action" }.first
		merchant = Merchant.find_merchant(key, params[key])
		if merchant.nil?
			render json: {
				"data": {}
			}
		else
			render json: MerchantSerializer.new(merchant)
		end
	end

	private

	def render_merchant(merchant)
		render json: MerchantSerializer.new(merchant)
	end
end