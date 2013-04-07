module Mongows
  require "mongo"
  require "mongows/configuration"
  require "mongows/version"
  require "mongows/app"

  def self.run options
    Mongows::App.run! 
  end

  def self.configure(&block)
    Configuration.class_eval(&block)
  end
end
