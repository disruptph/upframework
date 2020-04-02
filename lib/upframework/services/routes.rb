module Upframework
  module Services
    module Routes
      def self.load
        Rails.application.routes.draw do
          source_path = Rails.root.join('app', 'services')

          namespace :api, defaults: { format: 'json' } do
            Dir.glob("#{source_path}/*/").map{ |e| File.basename e }.each do |resource|
              #TODO: check resource exists in controller
              # config to exclude some services in the routes
              post "#{resource}/service/:service_name", to: "#{resource}#service"
            end
          end
        end
      end
    end
  end
end
