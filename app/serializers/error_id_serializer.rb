class ErrorIdSerializer
	def initialize(error_object, status)
		@error_object = error_object
		@status = status
	end

	def serialized_json
		{
			message: "your query could not be completed",
      errors: [
        {
					status: @status.to_s,
          title: @error_object.message,
        }
      ]
    }
	end
end