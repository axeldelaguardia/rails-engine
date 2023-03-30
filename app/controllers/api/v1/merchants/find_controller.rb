class Api::V1::Merchants::FindController < ApplicationController
	before_action :check_params
	rescue_from ValidationException, with: :error_serializer

	def show
		merchant = Merchant.find_merchant(params[:name])
		if merchant.nil?
			render json: {
				"data": {}
			}
		else
			render json: MerchantSerializer.new(merchant)
		end
	end

	private

	def check_params
		if params[:name].nil? 
			raise ValidationException.new "missing name attribute in query."
		elsif params[:name].empty?
			raise ValidationException.new "must include a name in query."
		end
	end

	def error_serializer(message)
		render json: ErrorSerializer.new(message, 400).id_error, status: 400
	end
end