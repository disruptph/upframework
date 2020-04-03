module Upframework
  module Services
    module Routes
      def self.load(namespace: nil, **options)
        scope_name = namespace

        Rails.application.routes.draw do
          source_path = Rails.root.join('app', 'services')

          service_routes = proc do
            Dir.glob("#{source_path}/*/").map{ |e| File.basename e }.each do |resource|
              # Create a post route for services
              # ex.
              # POST users/service/my_custom_service
              post "#{resource}/service/:service_name", to: "#{resource}#service"
            end
          end

          if scope_name
            namespace scope_name, defaults: { format: :json }, &service_routes
          else
            service_routes.call
          end
        end
      end
    end
  end
end
