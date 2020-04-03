module Upframework
  module Searches
    module Routes
      def self.load(namespace: nil, **options)
        Rails.application.routes.draw do
          # Create a route for searches
          # ex.
          # GET searches
          get [namespace, "search"].compact.join("/"), to: "searches#index"
        end
      end
    end
  end
end
