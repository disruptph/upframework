$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "upframework/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "upframework"
  spec.version     = Upframework::VERSION
  spec.authors     = ["jude_cali"]
  spec.email       = ["jcalimbas@fullscale.io"]
  spec.homepage    = "https://gitlab.com/disruptors/upframework"
  spec.summary     = "Rails framework extensions"
  spec.description = "Rails framework extensions"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
    #spec.metadata["allowed_push_host"] = "http://mygemserver.com"
  #else
    #raise "RubyGems 2.0 or newer is required to protect against " \
      #"public gem pushes."
  #end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.1"
  spec.add_dependency "cancancan", "~> 3.1.0"
  spec.add_dependency "jsonapi-serializer", "~> 2.0"
end
