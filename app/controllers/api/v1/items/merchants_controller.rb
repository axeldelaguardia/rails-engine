class Api::V1::Items::MerchantsController < ApplicationController
	def index
		render json: MerchantSerializer.new(Merchant.all)
	end

	def show
		begin
				merchant = Item.find(params[:item_id]).merchant
		rescue ActiveRecord::RecordNotFound => e
			render json: ErrorSerializer.new(e).id_error, status: 404
		else
			render json: MerchantSerializer.new(merchant)
		end
	end
end