class Api::V1::FindController < ApplicationController
	def index
		if params[:name] && (params[:max_price] || params[:min_price])
			invalid_search
		elsif params[:name]
			items = Item.find_by_name(params[:name])
			items.empty? ? no_records : (render json: ItemSerializer.new(items))
		elsif params[:max_price] || params[:min_price]
			items = Item.find_by_price(params)
			items.empty? ? no_records : (render json: ItemSerializer.new(items))
		end
	end

	def show
		key = params.keys.select { |key| key != "controller" && key != "action" }.first
		merchant = Merchant.find_merchant(key, params[key])
		if merchant.nil?
			no_records
		else
			render json: MerchantSerializer.new(merchant)
		end
	end

	private

	def no_records
		render json: {
			"message": "no records found with that keyword"
		}
	end

	def invalid_search
				render json: {
			"message": "cannot search by both name and unit price"
		}
	end
end