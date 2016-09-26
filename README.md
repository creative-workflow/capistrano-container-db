# Capistrano::Container::Db [![Gem Version](https://badge.fury.io/rb/capistrano-container-db.svg)](https://badge.fury.io/rb/capistrano-container-db)

Helps managing databases on local and remote stages, also on remote [docker](https://www.docker.com/) container for Capistrano 3.x.

This project is in an early stage but helps me alot dealing with my container deployments and keeps my code clean. It is not only ment for mysql, but at the moment there only supports mysql, feel free to contribute =)

This gem depends on [capistrano-container](https://github.com/creative-workflow/capistrano-container).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '>= 3.0.0'
gem 'capistrano-container-db'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-container-db

Dont forget to require the module in your Capfile:

```ruby
require 'capistrano/container/db'
```  

## Usage
### definition
To define and register a container do the following in your stage config or deploy.rb:

```ruby
...

# for usage in conjunction with capistrano-container
server('www.example.com', user: 'root', roles: %w{web})

container 'db',  roles: %w{db},
                 container_id: 'website_company_beta_db',
                 server: ['www.example.com']

# here the capistrano-container-db config comes

set :db_is_container, true
set :db_user, 'wordpress'
set :db_pass, 'wordpress'
set :db_name, 'my_wordpress_db_inside_docker'

...
```

This configures the db access for the db container. If 'db_is_container' is true, the gem uses the capistrano-container extension to select the container by name 'fetch(:db_container_name)' (defaults to 'db').

If the stage name is equal ':local', the gem runs export/import on local host.

If the stage is unequal ':local' and the param ':db_is_container' is false, the export/import will run on remote host.

### commandline tasks
```ruby
cap db:export               # export a local, remote or remote container mysql db
cap db:import               # import a local, remote or remote container mysql db
```

### default configuration
```ruby
set :db_user, 'root'
set :db_pass, ''
set :db_name, ''
set :db_remote_dump, '/tmp/dump.sql'
set :db_local_dump, 'config/db/dump.sql'
set :db_is_container, false
set :db_container_name, 'db'
```

## TODO
  * Implement provider pattern for other db engines.
  * Write tests.

## Changes
### Version 0.0.1
  * Initial release

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
