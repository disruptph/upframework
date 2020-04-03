module Upframework
  class BaseService
    attr_reader :errors

    class << self
      def run(attributes = {})
        attributes = Hash[attributes.to_h.map { |k, v| [k.to_sym, v] }]
        new(**attributes).tap(&:execute)
      end
    end

    def initialize(**attributes)
      @errors = []

      self.class.send(:attr_reader, *attributes.keys)

      #TODO: Remove. this should be done on the child class.
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      post_initialize(**attributes)
    end

    def post_initialize(**attributes)
    end

    def execute
    end

    def result
    end

    def success?
      @errors.blank?
    end

    def error?
      @errors.present?
    end

    def error_messages
      @errors.join('. ')
    end

    protected

    def add_error(error)
      @errors << error
    end
  end
end
