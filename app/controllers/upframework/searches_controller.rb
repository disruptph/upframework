module Upframework
  class SearchesController < ApplicationController
    skip_authorize_resource

    def index
      args = { current_ability: current_ability, current_user: current_user }
      args.merge!(permitted_params)

      resource_scope = search_class.run(args).result
      render_serialized resource_scope
    end

    private

    def search_class
      "#{params[:resource].classify}Search".constantize
    end

    def permitted_params
      excluded_keys  = %w[resource format controller action search]
      permitted_keys = params.keys - excluded_keys

      params.slice(*permitted_keys).permit(permitted_keys)
    end
  end
end
