# frozen_string_literal: true

module Upframework::ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      handle_exception(e)
    end

    protected

    def handle_exception(error)
      raise error if Rails.env.development?

      ExceptionNotifier.notify_exception(error, env: request.env)

      error_info = {
        success: false,
        error: 'Internal Server Error',
        status_code: 500,
        exception: "#{error.class.name} : #{error.message}"
      }

      render json: error_info, status: :internal_server_error
    end
  end
end
