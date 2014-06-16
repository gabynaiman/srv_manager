module SrvManager
  class Process

    attr_reader :command
    attr_reader :id

    def initialize(command)
      @command = command
    end
    
    def start
      return if alive?
      command.rvm ? rvm_start : default_start
      @id = wait_for_pid(command.pidfile) if command.pidfile
      LOGGER.info "Started process #{@id}"
    end

    def stop
      send_signal 'TERM'
      LOGGER.info "Stoped process #{@id}"
      @id = nil
    end

    def kill
      send_signal 'KILL'
      LOGGER.info "Killed process #{@id}"
      @id = nil
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

    private

    def default_start
      @id = ::Process.spawn command.env, 
                            command.text, 
                            chdir: command.dir, 
                            out: '/dev/null', 
                            err: '/dev/null'
      ::Process.detach @id
    end

    def rvm_start
      pid_file = File.expand_path "#{self.object_id}_#{Time.now.to_i}.pid", TMP_PATH
      params = {
        'SRV_COMMAND' => command.text, 
        'SRV_PIDFILE' => pid_file, 
        'CHDIR' => command.dir
      }
      rvm_pid = ::Process.spawn command.env.merge(params), 
                                RVM_RUNNER, 
                                out: '/dev/null', 
                                err: '/dev/null'
      ::Process.detach rvm_pid
      @id = wait_for_pid pid_file, true
    end

    def send_signal(signal)
      return unless alive?
      begin
        ::Process.kill signal, @id
      rescue Errno::ESRCH
      end
    end

    def wait_for_pid(filename, delete=false)
      Timeout.timeout(60) do
        loop do
          if File.exists? filename
            pid = File.read(filename).to_i
            File.delete filename if delete
            return pid
          end
          sleep 0.1
        end
      end
    rescue Timeout::Error
      nil
    end

  end
end