class Api::V1::ItemsController < ApplicationController
	def index
		render json: ItemSerializer.new(Item.all)
	end

	def show
		begin
			render json: ItemSerializer.new(Item.find(params[:id]))
		rescue ActiveRecord::RecordNotFound => e
			render json: ErrorIdSerializer.new(e).serialized_json, status: 404
		end
	end

	def create
		item = Item.new(item_params)
		if item.save
			render json: ItemSerializer.new(item), status: 201
		else
			render json: ItemErrorSerializer.new(item).serialized_json, status: 404
		end
	end

	def destroy
		item = Item.find(params[:id])
		item.single_invoices.destroy_all
		item.destroy
	end

	def update
		begin
			item = Item.find(params[:id])
		rescue ActiveRecord::RecordNotFound => e
			render json: ErrorIdSerializer.new(e).serialized_json, status: 404
		else
			if item.update(item_params)
				render json: ItemSerializer.new(item), status: 202
			else
				render json: ItemErrorSerializer.new(item).serialized_json, status: 404
			end
		end
	end

	private
	def item_params
		params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
	end
end