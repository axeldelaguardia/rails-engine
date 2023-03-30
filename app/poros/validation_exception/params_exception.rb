class ValidationException::ParamsException < ValidationException
	def initialize(msg="cannot search by both name and min/max price.", exception_type="custom")
    @exception_type = exception_type
    super(msg)
  end
end