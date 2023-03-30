class ValidationException::PriceException < ValidationException
	def initialize(msg="min or max price need to be an integer or a float.", exception_type="custom")
    @exception_type = exception_type
    super(msg)
  end
end