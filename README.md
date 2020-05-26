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
#### Controllers
```ruby
# app/controllers
# create,show,update,destroy methods are available by default
class ProjectsController < Upframework::ResourcesController
end
```

#### Searches
```ruby
#app/searches
class ProjectSearch < Upframework::BaseSearch
  def execute
    paginate_scope # paginate results
  end
end
```
```
#search api available in
/search?resource=Project&arg1=""&arg2=""
```

#### Services
```ruby
#app/services
class Project::SubmitService < Upframework::BaseService
  def execute
  end
end

service = Project::SubmitService.run
service.result => <Project: Instance>
service.success? => true/false
```

#### Routes
```ruby
#config/routes
mount Upframework::Engine => /path
```
routes being available
```
GET /search
POST /services/:service_name
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
