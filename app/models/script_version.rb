class ScriptVersion < ActiveRecord::Base
  belongs_to :user
  belongs_to :api_method

  validates_presence_of :api_method_id
  validates_associated :api_method

  validates_presence_of :user_id
  validates_associated :user

  validates_presence_of :script

  attr_accessible :api_method, :script, :message, :user

  before_create :set_version_number

  default_scope order("version DESC")


  def compare_with(other)
    Differ.diff_by_word(self.script, other.script)
  end

  def current?
    last_version = self.class.where(:api_method_id => self.api_method_id).first
    self.version == last_version.version
  end

  def restore!(params)
    user = params[:user]
    raise ArgumentError, "no user given" unless user

    self.api_method.script = self.script
    message = "Restored version #{self.version}\n\n#{self.message}"
    self.api_method.save_version(:user => user, :message => message)
  end

  protected

  def set_version_number
    last_version = self.class.where(:api_method_id => self.api_method_id).first
    self.version = last_version ? last_version.version + 1 : 1
  end
end
