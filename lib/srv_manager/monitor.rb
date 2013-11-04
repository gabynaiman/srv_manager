module SrvManager
  class Monitor

    attr_reader :pid

    def start(sleep_time=60)
      @pid = ::Process.fork do
        loop do
          Context.scoped do |ctx|
            ctx.services.each do |service|
              keep_alive service
            end
          end
          sleep sleep_time
        end
      end
      ::Process.detach @pid
    end

    def stop
      ::Process.kill 'TERM', pid if pid
    rescue Errno::ESRCH
    end

    def alive?
      pid && ::Process.kill(0, pid) ? true : false
    rescue Errno::ESRCH
      false
    end

    def keep_alive(service)
      service.processes.each do |process|
        LOGGER.info "Monitoring service: #{service.name} (#{process.id || 'stoped'})"
        if !process.started? && service.auto
          process.start
        elsif process.started? && !process.alive? 
          process.restart 
        end
      end
    end

  end
end