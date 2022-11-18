class BaseService
  class Error < ::StandardError
    attr_reader :record

    def initialize(record = nil)
      if record.respond_to?(:errors)
        super(record.errors.full_messages.to_sentence)
        @record = record
      else
        super
      end
    end
  end

  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def output
    fail NotImplementedError
  end

  def self.run(action, params)
    instance = new(params)
    instance.__send__ action
    instance
  end
end
