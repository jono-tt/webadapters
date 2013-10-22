class RemoteSession < RedisModel
  attr_accessor :id, :page_histories

  REMOTE_SESSION_ID_COUNTER = "remote_session_id_counter"

  def self.get(id)
    id ||= $redis.incr(REMOTE_SESSION_ID_COUNTER)
    self.new(id)
  end

  def initialize(id)
    self.id = id
    self.page_histories = []
  end

  def get(url, query = {}, headers = {})
    # nil here is for referer see documentation http://mechanize.rubyforge.org/Mechanize.html#method-i-get
    with_agent { |agent| agent.get(url, query, nil, headers) }
  end

  def post(url, params = {}, headers = {})
    with_agent(:post) { |agent| agent.post(url, params, headers) }
  end

  def set_agent_cookie_jar(agent)
    io = StringIO.new(cookie_jar || "")
    agent.cookie_jar.load_cookiestxt(io)
  end

  def store_cookie_jar_from_agent(agent)
    io = StringIO.new
    agent.cookie_jar.dump_cookiestxt(io)
    io.rewind
    self.cookie_jar = io.read
  end

  def cookie_jar
    self.get_key(:cookie_jar)
  end

  def cookie_jar=(jar)
    self.set_key(:cookie_jar, jar)
  end

  def store(key, value)
    self.set_key(key.to_sym, value)
  end

  def load(key)
    self.get_key(key.to_sym)
  end

  def success!(api_method_id)
    page_histories.each do |history|
      history.save_last_good(api_method_id)
    end
  end

  protected

  def with_agent(method = :get)
    agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
    self.set_agent_cookie_jar(agent)
    page = yield agent
    page_histories << PageHistory.create(
      :remote_session => self, :url => page.uri, :method => method, :content => page.content
    )
    self.store_cookie_jar_from_agent(agent)
    page
  end
end
