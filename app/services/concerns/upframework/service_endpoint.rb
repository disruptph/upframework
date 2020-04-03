module Upframework
  module ServiceEndpoint
    extend ::ActiveSupport::Concern

    included do
      def service
        service = service_class.run(**params.to_unsafe_h.symbolize_keys)

        if service.success?
          render_serialized service.result
        else
          render_errors service.errors
        end
      end

      private

      def service_class
        base_resource_name = controller_name.classify.pluralize
        service_name = params[:service_name]&.classify

        service_class = "::#{base_resource_name}::#{service_name}Service".safe_constantize
        raise ActionController::RoutingError.new('Not Found') if service_class.nil?

        service_class
      end
    end
  end
end
