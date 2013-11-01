module Srv
  class Monitor

    attr_reader :pid

    def start
      Srv.with_context do |ctx|
        @pid = ::Process.fork do
          sleep 1
          loop do
            Srv.with_context do |ctx|
              ctx.services.each do |service|
                keep_alive service
              end
            end
            sleep 5
          end
        end
        ::Process.detach @pid
      end
    end

    def stop
      ::Process.kill 9, pid if pid
    rescue Errno::ESRCH
    end

    def alive?
      pid && ::Process.kill(0, pid) ? true : false
    rescue Errno::ESRCH
      false
    end

    private

    def keep_alive(service)
      service.processes.each do |process|
        LOGGER.info "Monitoring service: #{service.name} (#{process.id})"
        process.restart if process.started? && !process.alive?
      end
    end

  end
end