module Srv
  class Process

    attr_reader :command
    attr_reader :id

    def initialize(command)
      @command = command
    end
    
    def start
      return if alive?
      @id = ::Process.spawn command.env, command.text, chdir: command.dir
      ::Process.detach @id
      LOGGER.info "Started process #{@pid}"
    end

    def stop
      return unless started?
      begin
        ::Process.kill 9, id
      rescue Errno::ESRCH
      end
      @id = nil
      LOGGER.info "Stoped process #{@pid}"
    end

    def restart
      stop if alive?
      start
    end

    def started?
      !id.nil?
    end

    def alive?
      started? && ::Process.kill(0, id) ? true : false
    rescue Errno::ESRCH
      false
    end

  end
end