class RedisModel
  KEY_TTL = 24 * 3600 # 24 hour - matches session lifetime from Publish

  def ttl_length
    KEY_TTL
  end

  def set_key(key, value)
    with_scoped_key(key) do |scoped_key|
      $redis.set(scoped_key, value)
      $redis.expire(scoped_key, self.ttl_length)
    end
  end

  def get_key(key)
    with_scoped_key(key) do |scoped_key|
      $redis.get(scoped_key)
    end
  end

  def with_scoped_key(key)
    yield "#{self.class.name.underscore}:#{self.id}:#{key}"
  end
end
