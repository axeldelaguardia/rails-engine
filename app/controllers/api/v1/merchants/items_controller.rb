class Api::V1::Merchants::ItemsController < ApplicationController
	def index
		begin
			merchant = Merchant.find(params[:merchant_id])
		rescue ActiveRecord::RecordNotFound => e
			render json: ErrorIdSerializer.new(e).serialized_json, status: 404
		else
			render json: ItemSerializer.new(merchant.items)
		end
	end
end