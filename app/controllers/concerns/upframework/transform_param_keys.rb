module Upframework::TransformParamKeys
  extend ActiveSupport::Concern

  included do
    prepend_before_action :underscore_params!

    def underscore_params!
      request.parameters.deep_transform_keys!(&:underscore)

      resource_name  = controller_name.singularize
      resource_klass = resource_name.classify.safe_constantize
      attributes     = resource_klass ? resource_klass.column_names.map(&:to_sym) : []

      attributes.concat(extra_params) if respond_to?(:extra_params, true)

      if resource_klass && params.key?(resource_name) && params[resource_name].class != Array
        params[resource_name].merge! params.permit(*attributes)
      end
    end
  end
end
