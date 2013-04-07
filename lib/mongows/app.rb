require "sinatra"
require "json"
module Mongows
  class App < Sinatra::Base

    def mongo
      Mongows::Configuration.mongo
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

    get '/:database' do
      mongo[params[:database]].collections.map { |e| e.name }
    end

    get '/:database/:collection' do
      mongo[params[:database]][params[:collection]].find({}).limit(10).map{ |e| e }
    end
  end
end