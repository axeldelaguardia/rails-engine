class ValidationException < StandardError
  def initialize(msg="Validation errors found.", exception_type="custom")
    @exception_type = exception_type
    super(msg)
  end
end