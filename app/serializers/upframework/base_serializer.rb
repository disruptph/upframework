module Upframework
  class BaseSerializer
    include JSONAPI::Serializer

    attr_reader :resource, :current_controller

    delegate :view_context, to: :current_controller

    set_key_transform :camel_lower
    attributes :created_at, :updated_at

    def initialize(resource, current_controller: nil, **args)
      @resource = resource
      @current_controller = current_controller

      if args[:format] == :minimal
        args[:fields] = set_format
      end

      if @current_controller && resource.respond_to?(:total_pages)
        args.merge!(pagination)
      end

      super(resource, **args)
    end

    def set_format
      resource_klass   = resource.class.name
      resource_klass   = resource.klass.name if resource_klass == 'ActiveRecord::Relation'
      resource_klass   = resource.first.class.name if resource.kind_of?(Array)

      { resource_klass.camelize(:lower) => [:id] }
    end

    def pagination
      {
        meta: {
          per_page:    resource.size,
          total_pages: resource.total_pages,
        },
        links: {
          prev: view_context.path_to_prev_page(resource),
          next: view_context.path_to_next_page(resource),
        },
      }.deep_transform_keys { |key| key.to_s.camelize(:lower).to_sym }
    end

    def self.default_includes(relations = [])
      @relations ||= relations
    end

    class << self
      delegate :url_helpers, to: :'Rails.application.routes'
    end
  end
end
