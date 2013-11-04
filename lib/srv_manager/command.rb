module SrvManager
  class Command

    attr_reader :text
    attr_reader :dir
    attr_reader :env
    attr_reader :rvm

    def initialize(text, options={})
      @text = text
      @dir = File.expand_path options[:dir].to_s
      @env = options[:env] || {}
      @rvm = options[:rvm] || false
    end

    def to_hash
      {text: text, dir: dir, env: env, rvm: rvm}
    end

  end
end