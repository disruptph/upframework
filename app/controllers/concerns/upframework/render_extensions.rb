# frozen_string_literal: true

module Upframework
  module RenderExtensions
    extend ActiveSupport::Concern

    included do
      # Args
      # resource      => instance of model
      # include       => include relations on response
      # format        => format can be :full(returns all default) or :minimal(returns only ids an types)
      # compound_opts => options, e.g: meta or links
      # opts          => extra options from render
      def render_serialized(resource, includes: [], format: :full, compound_opts: {}, **opts)
        render json: serialize_resource(resource, includes, format, compound_opts), **opts
      end

      # Args
      # resource      => instance of model
      # channel       => channel on where to broadcast response. If not provided will use the resource
      # include       => include relations on response
      # format        => format can be :full(returns all default) or :minimal(returns only ids an types)
      # compound_opts => options, e.g: meta or links
      # opts          => extra options from render
      def broadcast_serialized(channel, resource:, includes: [], format: :full, compound_opts: {})
        channel_klass = "::#{channel.class.name}Channel".constantize
        channel_klass.broadcast_to(channel, serialize_resource(resource, includes, format, compound_opts))
      end

      def render_errors(error_messages, status: :unprocessable_entity)
        render json: { errors: error_messages }, status: status
      end

      protected

      def serialize_resource(resource, includes, format, compound_opts)
        resource_klass = resource.class.name
        if resource_klass == 'ActiveRecord::Relation'
          resource_klass = resource.klass.name
        end
        # TODO: support empty arrays
        resource_klass = resource.first.class.name if resource.is_a? Array

        serializer_klass = "#{resource_klass}Serializer".constantize

        relations = serializer_klass.default_includes

        includes =
          if includes.is_a? String
            includes.split(",").map(&:underscore).map(&:to_sym)
          else
            Array(includes).map(&:to_sym)
          end

        relations.concat(includes.compact)

        serializer_klass.new(resource, include: relations, format: format, current_controller: self, **compound_opts).serializable_hash
      end
    end
  end
end
