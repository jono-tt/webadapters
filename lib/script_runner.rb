require("timeout")

module ScriptRunner

  class Environment
    attr_reader :remote_session
    attr_accessor :result_called

    def get(url, query = {}, headers = {})
      record_stats(:external) do
        remote_session.get(url, query, headers)
      end
    end

    def post(url, params = {}, headers = {})
      record_stats(:external) do
        remote_session.post(url, params, headers)
      end
    end

    def debug(*args)
      @response[:debug] ||= []
      args.each do |expr|
        @response[:debug] << expr.inspect
      end
    end

    def store(key, value)
      record_stats(:db) do
        remote_session.store(key, value)
      end
    end

    def load(key)
      record_stats(:db) do
        remote_session.load(key)
      end
    end

    def record_stats(label, &block)
      @response[:stats] ||= {}
      start = Time.now
        result = yield block if block_given?
      time = Time.now - start # result in seconds!
      @response[:stats][label] = @response[:stats][label].to_f + time
      result
    end

    def alarm(message)
      raise ScriptAlarm, message
    end

    # Prevent dangerous system calls. Override each method and call forbidden with __method__
    def forbidden(method)
      raise SecurityError, "You are not allowed to call #{method[/(.*)/, 1]}"
    end

    # If you alias these methods instead of defining them then you lose
    # the method name in the exception
    def `(*args); forbidden(__method__); end
    def system(*args); forbidden(__method__); end
    def eval(*args); forbidden(__method__); end
    def syscall(*args); forbidden(__method__); end

    def result(content = nil, &block)
      raise ArgumentError, "result should be called only once, at the end of the script. Please remove any additional 'result' statements" if self.result_called
      self.result_called = true
      if block_given?
        block_response = yield

        if content.is_a?(Hash) && block_response.is_a?(Hash)
          content.merge!(block_response)
        elsif content.nil?
          content = block_response
        else
          content = [content, block_response].compact
        end
      end

      @response.merge({ response: content })
    end

    def initialize(script, extra_params = {})
      unless extra_params.respond_to?(:has_key?) && extra_params.has_key?(:remote_session)
        raise ArgumentError, "no remote session given"
      end

      @script = script
      @remote_session = extra_params.delete(:remote_session)
      @response = {}

      extra_params.each_pair do |name, value|
        self.class.send(:define_method, name, lambda { value })
      end
    end

    def run
      record_stats(:total) do
        result = instance_eval(@script)
      end
    end
  end


  def self.run(code_str, extra_params = {})
    #Environment.new(code_str, extra_params).run
    result = nil
    thread = Thread.new do
       result = Environment.new(code_str, extra_params).run
    end.run
    thread.join
    result
  end
end
