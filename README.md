# Upframework
Add features on top of Rails, Especially for APIs. This was created to make structural code reusable to other projects (not solving the same problem all over again). And to make the main application less bloated and only contain domain specific code as much as possible.

#### The following features are available.
- Creates (create, read, update, destroy) action methods for resources.
- Has render helpers for API or socket responses. ex. Converting models to its designated serializer.
- Converts snake case request params (from js standard) to underscore params (ruby standard)
- Searches layer under app/searches. Usually used for form searches.
- Services layer under app/services. For single responsibility domain-specific logic code.
- Exception notifier and API error response handler.

##  Basic Usage
####Controllers
```ruby
#app/controllers
class ProjectsController < Upframework::ResourcesController
end
```

####Searches
```ruby
#app/searches
class ProjectSearch < Upframework::BaseSearch
end
```

####Services
```ruby
#app/services
class  Project::SubmitService < Upframework::BaseService
end
```

####Routes
app/services
```ruby
#config/routes
mount Upframework::Engine => /path
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'upframework'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install upframework
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
