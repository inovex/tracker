$:.unshift File.dirname(__FILE__)
require 'tracker'

enable :logging
set :environment, :production
set :port, 9000
run Sinatra::Application
