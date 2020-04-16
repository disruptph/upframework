module Upframework
  class Engine < ::Rails::Engine
    isolate_namespace Upframework

    config.to_prepare do
      ApplicationController.include ::Upframework::ApiExtensions
    end
  end
end
