require 'fileutils'
require 'logger'

Dir.glob(File.expand_path('srv/*.rb', File.dirname(__FILE__))).each { |f| require f }



module Srv

  LOG_FILE = File.expand_path('../logs/srv.log', File.dirname(__FILE__))

  FileUtils.mkpath File.dirname(LOG_FILE) unless Dir.exists? File.dirname(LOG_FILE)

  LOGGER = Logger.new LOG_FILE

  def self.with_context
    context = Context.load
    begin
      yield context
    ensure
      Context.save context
    end
  end

end