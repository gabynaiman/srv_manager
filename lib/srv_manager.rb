require 'fileutils'
require 'logger'
require 'timeout'

Dir.glob(File.expand_path('srv_manager/*.rb', File.dirname(__FILE__))).each { |f| require f }


module SrvManager

  PATH = File.expand_path '.srv_manager', Dir.home
  FileUtils.mkpath PATH unless Dir.exists? PATH

  TMP_PATH = File.expand_path 'tmp', PATH
  FileUtils.mkpath TMP_PATH unless Dir.exists? TMP_PATH

  LOG_FILE = File.expand_path 'events.log', PATH
  LOGGER = Logger.new LOG_FILE

  RVM_RUNNER = File.expand_path '../rvm/runner', File.dirname(__FILE__)

end