module CreditCard
	class Error
		attr_reader :typee, :error
		def initialize(options)
			@type = options[:type]
			@error = options[:error]
		end
	end
end