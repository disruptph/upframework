require "upframework/engine"

module Upframework
  def self.configuration
    @configuration ||= {}
  end

  def self.configure
    yield(configuration)
  end
end

require "upframework/services/routes"
