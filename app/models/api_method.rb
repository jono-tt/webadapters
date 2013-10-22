require_dependency 'script'

class ApiMethod < ActiveRecord::Base
  belongs_to :site
  has_many :script_versions, :dependent => :destroy
  has_many :alarms, :dependent => :destroy

  attr_accessible :name, :script, :site_id, :draft
  validates_presence_of :name
  validates_format_of :name, :with => /^[\w\d\-]+$/, :message => "can only contain letters, numbers and -"
  validates_uniqueness_of :name, :scope => :site_id

  validates_associated :site

  def save_version(params)
    user = params[:user]
    message = params[:message]
    raise ArgumentError, "no user specified" unless user
    raise ArgumentError, "no message specified" unless message
    transaction do
      self.save!
      self.script_versions.create!(:user => user, :message => message, :script => self.script)
    end
  end

  def save_draft(new_draft)
    if clean_extra_whitespace(new_draft) != clean_extra_whitespace(self.script)
      update_attributes({:draft => new_draft})
    end
  end

  def draft_diff
    Differ.diff_by_word(self.script, self.draft).format_as(:html)
  end

  def clean_extra_whitespace(str)
    str.to_s.strip.gsub(/[\r\n]+/, "\n").gsub(/\s+/, " ")
  end

  def clear_draft
    self.draft = nil
  end

  def draft?
    self.draft && !self.draft.empty?
  end

  def run_script(request_params, remote_session)
    script = Script.new(self.script)
    script.run({ :params => request_params, :remote_session => remote_session })
    if script.alarm_raised?
      Alarm.create_or_increment!(:api_method => self, :message => script.error, :remote_session => remote_session)
    end

    if script.successful?
      remote_session.success!(self.id)
    end
    script
  end

  def load_default_script_if_required
    if script.blank?
      script_file = File.join(Rails.root, "config", "default_script")
      self.script = File.read(script_file)
    end
  end

end
