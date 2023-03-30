class Api::V1::Items::FindController < ApplicationController
	before_action :check_price_params
	before_action :check_name_params
	rescue_from ActiveRecord::RecordNotFound, with: :error_serializer
	rescue_from ValidationException, with: :error_serializer
	
	def index
		if params[:name] && (check_min_max_price)
			raise ValidationException.new "name and min/max price cannot be used together"
		elsif params[:name]
			items = Item.find_by_name(params[:name])
			render json: ItemSerializer.new(items)
		elsif check_min_max_price
			items = Item.find_by_price(params)
			render json: ItemSerializer.new(items)
		else
			raise ValidationException.new "min_price and max_price must be greater than or equal to 0"
		end
	end

	private
	def check_min_max_price
		params[:max_price] && params[:max_price].to_i >= 0 || 
		params[:min_price] && params[:min_price].to_i >= 0
	end

	def check_price_params
		return true if params[:min_price].nil? && params[:max_price].nil?
		if params[:min_price].nil? && valid_price?(params[:max_price])
			true
		elsif valid_price?(params[:max_price]) && params[:min_price].nil?
			true
		elsif !valid_price?(params[:min_price]) || !valid_price?(params[:max_price])
			raise ValidationException.new "min or max price need to be an integer or a float."
		end
	end

	def check_name_params
		return true if params[:name].nil?
		if params[:name].empty?
			raise ValidationException.new "must include a name in query."
		end
	end

	def valid_price?(price)
		return true if price.nil?
		Float(price) != nil rescue false
	end

	def error_serializer(message)
		render json: ErrorSerializer.new(message, 400).id_error, status: 400
	end
end