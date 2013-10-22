class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :enabled
  # attr_accessible :title, :body

  validates_presence_of :password_confirmation, :if => :password_required?
  
  def self.find_for_authentication(conditions)
    conditions[:enabled] = true
    find(:first, :conditions => conditions)
  end

  def disable!
    self.update_attributes(:enabled => false)
  end
  
  def enable!
    self.update_attributes(:enabled => true)
  end

  def disabled?
    !self.enabled?
  end
end
