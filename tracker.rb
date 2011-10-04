$:<<File.join(File.dirname(__FILE__), "lib")
require 'rubygems'  # not necessary for Ruby 1.9
gem 'tilt','=1.2.2' # sinatra erb support doesn't work with tilt 1.3.x
require 'sinatra'
require 'uri'
require 'json'
require 'mongo'

DB = Mongo::Connection.new("localhost", 27017).db('tracker')

def mongo_id
  BSON::ObjectId(params[:id])
end

get '/' do
  @tasks = DB.collection(:tasks).find()
  
  erb :start
end

post '/start' do
  id = DB.collection(:tasks).save(
    {'activity' => params[:activity], 'start' => Time.now.to_i}
  )
  @task = DB.collection(:tasks).find_one({'_id' => id})
  
  erb :stop
end

post '/stop' do
  DB.collection(:tasks).update(
    {'_id' => mongo_id}, {'$set' => {'stop' => Time.now.to_i}}
  )
  redirect '/'
end

