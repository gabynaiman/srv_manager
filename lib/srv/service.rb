module Srv
  class Service
  
    attr_reader :name
    attr_reader :command
    attr_reader :processes

    def initialize(name, command, options={})
      @name = name
      
      @command = Command.new command, 
                             dir: options[:dir], 
                             env: options[:env]
      
      @processes = (options[:processes] || 1).times.map do 
        Process.new @command
      end
    end

    def start
      processes.each(&:start)
      LOGGER.info "Started service #{name}"
    end

    def stop
      processes.each(&:stop)
      LOGGER.info "Stoped service #{name}"
    end

    def restart
      processes.each(&:restart)
    end

  end
end