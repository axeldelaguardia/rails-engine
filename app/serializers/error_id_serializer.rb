class ErrorIdSerializer
	def initialize(error_object)
		@error_object = error_object
	end

	def serialized_json
		{
			message: "your query could not be completed",
      errors: [
        {
          message: @error_object.message,
        }
      ]
    }
	end
end