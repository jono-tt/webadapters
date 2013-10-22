require_dependency 'footprints_alarm_notifier'

class Alarm < ActiveRecord::Base
  attr_accessor :remote_session

  belongs_to :api_method

  validates_presence_of :api_method_id
  validates_associated :api_method
  validates_presence_of :remote_session, :on => :create

  attr_accessible :api_method, :message, :responses, :remote_session, :footprints_issue_id, :count

  before_create :initialize_count
  before_create :store_responses
  after_create :send_to_footprints

  default_scope order("created_at DESC")

  ALARM_RATE_LIMIT_PERIOD = 5.minutes

  # This rate limits alarm creation. If a recent alarm already exists for the api method
  # then we increment the count for that, rather than creating a new alarm.
  def self.create_or_increment!(params)
    alarm = Alarm.new(params)
    raise ArgumentError, alarm.errors.full_messages.join(",") unless alarm.valid?

    redis_key = "alarm:#{alarm.site.name}:#{alarm.api_method.name}:alarm_id"
    existing_alarm_id = $redis.get(redis_key)
    if existing_alarm_id
      alarm = Alarm.find(existing_alarm_id)
      count = alarm.count
      count = 1 if count < 1
      alarm.update_attributes(:count => count + 1)
    else
      alarm.save!
      $redis.set(redis_key, alarm.id)
    end

    puts "Calling expire with #{redis_key}, #{ALARM_RATE_LIMIT_PERIOD}"
    $redis.expire(redis_key, ALARM_RATE_LIMIT_PERIOD)
  end

  def parsed_responses
    @parsed_responses ||= JSON::parse(responses || "{}")
  end

  def site
    @site ||= self.api_method.site
  end

  protected

  def initialize_count
    self.count ||= 1
  end

  def store_responses
    responses = []
    remote_session.page_histories.each do |page_history|
      responses << {
        request_url: page_history.url.to_s,
        request_method: page_history.method,
        alarm_response: page_history.content,
        last_good_response: page_history.last_good_content(self.api_method_id)
      }
    end
    self.responses = responses.to_json
  end

  def send_to_footprints
    Resque.enqueue(FootprintsAlarmNotifier, self.id)
  end
end
