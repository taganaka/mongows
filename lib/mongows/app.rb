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

    get '/' do
      mongo.database_names
    end

    get '/:database/' do
      db = use_database(params[:database]) || halt(404)
      db.collections.map { |e| e.name }
    end

    get '/:database/:collection/' do
      db = use_database(params[:database]) || halt(404)
      db[params[:collection]].find({}).limit(10).map{ |e| e }
    end
  end
end