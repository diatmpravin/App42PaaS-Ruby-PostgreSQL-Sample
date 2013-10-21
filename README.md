App42PaaS-Ruby-PostgreSQL-Sample
================================

Sample Ruby App with PostgreSQL for App42 PaaS Platform

## Getting Start with App42

1. Setup infrastructure for required environment
2. Create service
3. Deploy a Ruby on Rails application

### Setup infrastructure for required environment

    $ app42 setupInfra   
    
#### Prerequisite production environment configuration

Gemfile(app_root_dir/Gemfile)

If you are use a different database in development.
Create or change the production group to include pg, Ensure the pg gem is defined in your Gemfile 

    group :production do 
      gem 'pg'
    end

config

In config/environments/production.rb change

    config.assets.compile = false => config.assets.compile = true

and

    config.serve_static_assets = false => config.serve_static_assets = true

and uncomment below configuration.

    config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

### Create service

    $ app42 createService
    
DB Configure for Production environment (application_root_dir/config/database.yml) 

    adapter: postgres
    host: <host>
    port: <port>
    database: <database name> 
    username: <user_name>
    password: '<password>'
    
### Deploy a Ruby on Rails application

    $ app42 deploy

#### Get application details:

    $ app42 appInfo --app AppName    
    
Visit your application:

