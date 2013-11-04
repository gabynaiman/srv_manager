module SrvManager
  class Context

    def monitor
      @monitor ||= Monitor.new
    end

    def services
      @services ||= []
    end

    def clean
      services.each(&:stop)
      services.clear
    end

    def load(json)
      clean
      @services = json['services'].map { |js| Service.parse js }
    end

    def self.scoped(options={})
      context = load
      monitor_running = options[:safe] && context.monitor.alive?
      context.monitor.stop if monitor_running
      begin
        yield context
      ensure
        save context
        if monitor_running
          context.monitor.start 
          save context
        end
      end
    end

    def to_hash
      {services: services.map(&:to_hash)}
    end

    private

    def self.load
      LOGGER.info "Reading context from #{data_file}"
      return new unless File.exists? data_file
      Marshal.load(File.read(data_file))
    end

    def self.save(context)
      LOGGER.info "Saving context to #{data_file}"
      FileUtils.mkpath File.dirname(data_file) unless Dir.exists? File.dirname(data_file)
      File.write data_file, Marshal.dump(context)
    end

    def self.data_file
      File.expand_path('.srv_manager/context.bin', Dir.home)
    end

  end
end