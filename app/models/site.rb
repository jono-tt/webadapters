class Site < ActiveRecord::Base
  attr_accessible :name, :archived
  has_many :api_methods

  validates_presence_of :name
  validates_uniqueness_of :name

  scope :archived, where(:archived => true)
  scope :unarchived, where(:archived => false)

  def to_param
    "#{super}-#{self.name.gsub(/\s|'|\t|\/|[^a-zA-Z0-9\_\-\.]/,"-")}"
  end

  def archive
    self.update_attributes({archived: true})
  end

  def unarchive
    self.update_attributes({archived: false})
  end

end
