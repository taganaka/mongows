require "mongo"
module Mongows
  class Configuration

    def self.mongo(value = nil)
      return @mongo = value unless value.nil?
      @mongo ||= Mongo::MongoClient.from_uri(self.mongo_uri)
      @mongo
    end

    def self.mongo_uri(value = nil)
      return @mongo_uri = value unless value.nil?
      @mongo_uri || "mongodb://localhost"
    end

    def self.server_port(value = nil)
      return @server_port = value unless value.nil?
      @server_port || 4567
    end

    def self.reset(*properties)
      reset_variables = properties.empty? ? instance_variables : instance_variables.map { |p| p.to_s} & \
                                                                  properties.map         { |p| "@#{p}" }
      reset_variables.each { |v| instance_variable_set(v.to_sym, nil) }
    end

  end
end