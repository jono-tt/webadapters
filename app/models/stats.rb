class Stats

  attr_accessor :id

  TIME_COUNT = 25

  def initialize(api_method_id)
    @id = api_method_id
  end

  def store(time)
    with_scoped_key("times") do |scoped_key|
      $redis.lpush(scoped_key, time)
      if self.count > TIME_COUNT
        $redis.ltrim(scoped_key, 0, (TIME_COUNT - 1) )  # LTRIM mylist 0 99
      end
    end
  end

  def count
    with_scoped_key("times") do |scoped_key|
      $redis.llen(scoped_key)
    end
  end

  def times
    with_scoped_key("times") do |scoped_key|
      $redis.lrange(scoped_key, 0, (TIME_COUNT - 1) )
    end
  end

  def average_time
    result = nil
    times = self.times
    if times && times.length > 0
      avg = times.inject(0.0){|acc, i| acc += i.to_f} 
      avg = avg / self.count.to_i if avg > 0.0
      result = (avg.to_f * 1000.0).to_i / 1000.0
    end
    result
  end

  def with_scoped_key(key)
    yield "stats:#{self.id}:#{key}"
  end

end
