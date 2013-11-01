module Srv
  class Command

    attr_reader :text
    attr_reader :dir
    attr_reader :env

    def initialize(text, options={})
      @text = text
      @dir = File.expand_path options[:dir].to_s
      @env = options[:env] || {}
    end

  end
end