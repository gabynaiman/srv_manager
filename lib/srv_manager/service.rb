module SrvManager
  class Service
  
    attr_reader :name
    attr_reader :command
    attr_reader :processes
    attr_reader :auto

    def initialize(name, command, options={})
      @name = name
      
      @command = Command.new command, options
      
      @processes = (options[:processes] || 1).times.map do 
        Process.new @command
      end

      @auto = options[:auto] || false
    end

    def start
      processes.each(&:start)
      LOGGER.info "Started service #{name}"
    end

    def stop
      processes.each(&:stop)
      LOGGER.info "Stoped service #{name}"
    end

    def kill
      processes.each(&:kill)
      LOGGER.info "Killed service #{name}"
    end

    def restart
      processes.each(&:restart)
    end

    def started?
      processes.map(&:started?).reduce(:|)
    end

    def to_hash
      {name: name, command: command.to_hash, processes: processes.count, auto: auto}
    end

    def self.parse(json)
      new json['name'], 
          json['command']['text'], 
          dir: json['command']['dir'], 
          env: json['command']['env'], 
          rvm: json['command']['rvm'], 
          pidfile: json['command']['pidfile'], 
          processes: json['processes'],
          auto: json['auto']
    end

  end
end