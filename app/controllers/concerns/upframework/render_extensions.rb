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
      def render_serialized(resource, options)
        options = options.is_a?(ActionController::Parameters) ? options.to_unsafe_h.symbolize_keys : options
        options[:current_controller] = self

        render json: serialize_resource(resource, options).as_json, **options.except(:format)
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

      def serialize_resource(resource, options)
        resource_klass = resource.class.name

        if resource.respond_to? :each
          ::Serializer::Collection.new(resource, **options)
        else
          ::Serializer::Item.new(resource, **options)
        end
      end
    end
  end
end
