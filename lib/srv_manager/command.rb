module SrvManager
  class Command

    attr_reader :text
    attr_reader :dir
    attr_reader :env
    attr_reader :rvm
    attr_reader :pidfile

    def initialize(text, options={})
      @text = text
      @dir = File.expand_path options[:dir].to_s
      @env = options[:env] || {}
      @rvm = options[:rvm] || false
      @pidfile = File.expand_path(options[:pidfile]) if options[:pidfile]
    end

    def to_hash
      {text: text, dir: dir, env: env, rvm: rvm, pidfile: pidfile}
    end

  end
end