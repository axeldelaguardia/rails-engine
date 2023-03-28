class ItemErrorSerializer
	def initialize(item)
		@item = item
	end

	def serialized_json
		hash = {}
		hash[:message] = "your query could not be completed"
		hash[:errors] = []
		@item.errors.each do |error|
				hash[:errors] << {
						error.attribute => error.options[:message]
					}
		end
		hash
	end
end