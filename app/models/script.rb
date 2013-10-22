require_dependency 'script_runner'

class ScriptAlarm < StandardError; end

class Script
  attr_accessor :script
  attr_reader :success, :error, :result, :warning, :line, :debug, :stats

  def initialize(script)
    self.script = script
  end

  def run(*args)
    @raw_result = ScriptRunner.run(self.script, *args)
    if @raw_result.is_a?(Hash)
      @result = @raw_result[:response]
      @debug = @raw_result[:debug]
      @stats = @raw_result[:stats]
    else
      @result = nil
    end

    if @result.nil?
      @warning = "The script produced no output. Did you forget to add 'result' to the end?"
    end
    @success = true

  rescue ScriptAlarm => script_alarm
    @success = false
    @alarm_raised = true
    @error = script_alarm.message

  rescue SyntaxError => syntax_error
    @success = false
    _, line_no, message = syntax_error.message.split(':')
    message.sub!(" syntax error, ", '')
    @error = "Syntax error on line #{line_no}: #{message}"
    @line = line_no.to_i

  rescue Exception => exception
    @success = false
    message = exception.message.sub(/ for #<ScriptRunner::Environment.*$/, '')
    @error = exception.class.name + ": " + message
  end

  def successful?
    return @success
  end

  def alarm_raised?
    return @alarm_raised
  end
end
