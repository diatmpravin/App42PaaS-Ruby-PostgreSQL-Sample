require 'erubis'
require 'active_record'
require 'yaml'
require 'json'

# initialize database configuration file
dbconfig = YAML::load(File.open('config/database.yml'))
# establish database connection
ActiveRecord::Base.establish_connection(dbconfig)

# create table
ActiveRecord::Migration.class_eval do
  create_table :users do |t|
    t.string   :name
    t.string   :email
    t.string   :desc

    t.timestamps
  end
end

class App
  # call method, takes a single hash parameter and returns
  # an array containing the response status code, HTTP response
  # headers and the response body as an array of strings.  
  def call env
    $params = nil
    $params = Rack::Utils.parse_nested_query(env["rack.input"].read)
    path = env['PATH_INFO']
    routes = ['index','new', 'data']
    action = path.split("/")
    if action.size > 0 and routes.include? action[1]
      body = User.new.send(action[1])
    elsif action.size == 0
      body = User.new.send('new')
    else
      body = 'Page not found' 
    end
    status = 200
    header = {"Content-Type" => "text/html"}

    [status, header, [body]]
  end
end

# User model that inherit ActiveRecored
class User < ActiveRecord::Base
  def new
    render :file => 'users/new'
  end

  def index
    @users = User.all
    render :file => 'users/index'
  end

  def data
    User.create(:name => $params['name'], :email => $params['email'], :desc => $params['desc'])
    @users = User.all
    render :file => 'users/index'
  end

  def render(option)
    @body = render_erb_file('views/' + option[:file] + '.erb')
  end

  def render_erb_file(file)
    input = File.read(file)
    eruby = Erubis::Eruby.new(input)
    @body = eruby.result(binding())
  end
end