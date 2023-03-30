class Api::V1::Merchants::ItemsController < ApplicationController
	def index
		begin
			merchant = Merchant.find(params[:merchant_id])
		rescue ActiveRecord::RecordNotFound => e
			render json: ErrorSerializer.new(e).id_error, status: 404
		else
			render json: ItemSerializer.new(merchant.items)
		end
	end
end