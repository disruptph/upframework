module Upframework
  module ApiExtensions
    extend ::ActiveSupport::Concern

    included do
      include ::DeviseTokenAuth::Concerns::SetUserByToken
      include ::Upframework::ErrorHandler
      include ::Upframework::TransformParamKeys
      include ::Upframework::ServiceEndpoint
      include ::Upframework::RenderExtensions

      # need to skip this on non-resource controller
      # > skip_authorize_resource
      authorize_resource unless: :devise_controller?

      rescue_from CanCan::AccessDenied do |exception|
        respond_to do |format|
          format.json { render json: { success: false, error: exception.message, status_code: 403 }, status: :forbidden }
          format.html { redirect_to main_app.root_url, alert: exception.message }
        end
      end

      protected

      def extra_params
        [] # Override in specific controllers for custom params
      end
    end
  end
end
