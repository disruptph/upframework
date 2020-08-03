module Upframework
  class ResourcesController < ApplicationController
    before_action :set_base_resource

    def show
      base_resource

      yield if block_given?
      render_serialized base_resource
    end

    def update
      if base_resource.update(base_resource_params)
        yield if block_given?
        render_serialized base_resource
      else
        render_errors base_resource.errors.full_messages
      end
    end

    def index
      base_resource

      yield if block_given?
      render_serialized base_resource, includes: params[:includes]
    end

    def create
      if base_resource.save

        yield if block_given?
        render_serialized base_resource
      else
        render_errors base_resource.errors.full_messages
      end
    end

    def destroy
      base_resource.destroy
      head :no_content
    end

    private

    def base_resource
      if params[:id]
        instance_variable_get("@#{base_resource_name}")
      else
        instance_variable_get("@#{base_resource_name.pluralize}")
      end
    end

    def set_base_resource
      data =
        if params[:id]
          base_resource_class.find(params[:id])
        elsif action_name == 'index'
          base_resource_class.accessible_by(current_ability).where(base_resource_params || {})
        elsif action_name == 'create'
          base_resource_class.new(base_resource_params)
        end

      resource_name = %w[index create].include?(action_name) \
        ? base_resource_name.pluralize \
        : base_resource_name

      instance_variable_set("@#{resource_name}", data) if data
    end

    def base_resource_params
      base_name = base_resource_name

      base_name = base_name.pluralize unless params.key?(base_name)

      params.fetch(base_name).permit(*permitted_columns)
    end

    def permitted_columns
      columns = base_resource_class.accessible_fields_by(accessors)
      columns.concat(extra_params)
    end

    def accessors
      super || current_user
    end

    def base_resource_name
      controller_name.singularize
    end

    def base_resource_class
      base_resource_name.classify.safe_constantize
    end
  end
end
