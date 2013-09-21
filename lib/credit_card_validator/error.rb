module CreditCardValidator
  class Error
    attr_reader :typee, :message
    def initialize(options)
      @type = options[:type]
      @message = options[:message]
    end
  end
end