class Api::V1::MerchantsController < ApplicationController
	def index
		render json: MerchantSerializer.new(Merchant.all)
	end

	def show
		begin
			merchant = Merchant.find(params[:id])
		rescue ActiveRecord::RecordNotFound => e
			render json: ErrorIdSerializer.new(e).serialized_json, status: 404
		else
			render json: MerchantSerializer.new(merchant)
		end
	end
end