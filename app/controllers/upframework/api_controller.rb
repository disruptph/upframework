module Upframework
  class ApiController < ::ApplicationController
    include ::DeviseTokenAuth::Concerns::SetUserByToken
    include ::Upframework::ErrorHandler
    include ::Upframework::TransformParamKeys
    include ::Upframework::CrudEndpoint
    include ::Upframework::ServiceEndpoint
    include ::Upframework::RenderExtensions

    before_action :authenticate!

    # need to skip this on non-resource controller
    # > skip_authorize_resource
    authorize_resource

    rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.json { render json: { success: false, error: exception.message }, status: :forbidden }
        format.html { redirect_to main_app.root_url, alert: exception.message }
      end
    end

    def authenticate!
      super || authenticate_user!
    end

    protected

    def extra_params
      [] # Override in specific controllers for custom params
    end
  end
end
