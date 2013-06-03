require 'sinatra/base'
require "sinatra/reloader"
require 'mongo'
require "sinatra/json"
require 'multi_json'
require 'json'

include Mongo

mongo_client = MongoClient.new('localhost', 27017)

class App < Sinatra::Base
  helpers Sinatra::JSON
	configure :development do
    register Sinatra::Reloader
  end

  before do
    @mongo_client = MongoClient.new('localhost', 27017)
  end

  get '/' do
    'hello'
  end

  get '/databases' do
    json :dbs => @mongo_client.database_names
  end

  get '/documents/:db/:collection' do
    json :documents => @mongo_client["#{params[:db]}"]["#{params[:collection]}"].find().limit(10).to_a
  end

  run! if app_file == $0
end