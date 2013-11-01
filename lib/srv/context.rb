module Srv
  class Context

    def monitor
      @monitor ||= Monitor.new
    end

    def services
      @services ||= []
    end

    def self.load
      LOGGER.info 'Reading context'
      return new unless File.exists? data_file
      Marshal.load(File.read(data_file))
    end

    def self.save(context)
      LOGGER.info 'Saving context'
      FileUtils.mkpath File.dirname(data_file) unless Dir.exists? File.dirname(data_file)
      File.write data_file, Marshal.dump(context)
    end

    private

    def self.data_file
      File.expand_path('../../data/context.bin', File.dirname(__FILE__))
    end

  end
end