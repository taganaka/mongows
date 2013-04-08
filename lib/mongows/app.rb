require "sinatra"
require "json"
module Mongows
  class App < Sinatra::Base

    def mongo
      Mongows::Configuration.mongo
    end

    def database_exists?(db_name)
      mongo.database_names.include? db_name
    end

    def use_database(db_name)
      return nil unless database_exists?(db_name)
      mongo.db(db_name)
    end

    before do
      content_type 'application/json'
    end

    after do
      if params[:pretty]
        body(JSON.pretty_generate(body))
      else
        body(body.to_json)
      end
    end

    # Get the list of available databases
    get '/' do
      mongo.database_names
    end

    # It creates a new database
    post '/' do
      db_name = params[:name] || halt(500)
      if database_exists?(db_name)
        status 200
      else
        mongo.db(db_name).collection_names
        status 201
      end
      {}
    end

    # It deletes a database
    delete '/' do
      db_name = params[:name] || halt(500)
      if database_exists?(db_name)
        mongo.drop_database(db_name)
      else
        status 500
      end
      {}
    end

    get '/:database/?' do
      db = use_database(params[:database]) || halt(404)
      db.collections.map { |e| e.name }
    end

    get '/:database/:collection/?' do
      db = use_database(params[:database]) || halt(404)
      db[params[:collection]].find({}).limit(10).map{ |e| e }
    end

    get '/:database/:collection/:id/?' do
      db = use_database(params[:database]) || halt(404)
      record = db[params[:collection]].find({_id:BSON::ObjectId(params[:id])}).limit(1).first
      record || halt(404)
    end

    post '/:database/:collection/?' do
      data = JSON.parse(request.body.string)
      halt(500) if data.nil? || !data.kind_of?(Hash)
      db = use_database(params[:database]) || halt(500)
      db[params[:collection]].insert(data)
      data
    end
  end
end