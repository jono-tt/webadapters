class PageHistory < RedisModel
  attr_accessor :id, :url, :content, :method

  def self.create(params)
    self.new(params).save_current
  end

  def initialize(params)
    raise ArgumentError, "remote session not given" unless params[:remote_session]
    raise ArgumentError, "url not given" unless params[:url]
    raise ArgumentError, "content not given" unless params[:content]
    raise ArgumentError, "HTTP method not given" unless params[:method]

    self.id = params[:remote_session].id
    self.url = params[:url]
    self.content = params[:content]
    self.method = params[:method]
  end

  def save_current
    self.save(:current)
  end

  def save_last_good(api_method_id)
    self.save(:last_good)
    self.save_last_good_for_api_method(api_method_id)
  end

  def save(label)
    self.set_key(key_for(label), self.content)
    self
  end

  def save_last_good_for_api_method(api_method_id)
    key = key_for_api_method(api_method_id)
    $redis.set(key, self.content)
  end

  def get_last_good_for_api_method(api_method_id)
    key = key_for_api_method(api_method_id)
    $redis.get(key)
  end

  def last_good_content(api_method_id)
    self.get_key(key_for(:last_good)) || 
      self.get_last_good_for_api_method(api_method_id)
  end

  protected

  def key_for(label)
    "#{self.method}:#{self.url}:#{label}"
  end

  def key_for_api_method(id)
    key = "api_method:#{id}:" + key_for(:last_good)
  end

end
