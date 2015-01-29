class UserSession < ActiveRecord::Base
  attr_readonly :id, :user_id, :ip_addr, :user_agent, :created_at
  attr_accessible :ip_addr, :user_agent
  attr_accessible :status, as: :admin
  
  belongs_to :user
  
  before_create do
    self.last_activity_at = current_time_from_proper_timezone
  end
  
  validates :status, inclusion: { in: ['active', 'signed_out', 'expired', 'deleted'] }
  
  def self.active
    where(status: :active)
  end
  
  def self.inactive
    where(status: ['signed_out', 'expired', 'deleted'])
  end
  
  def self.get_active_session(id)
    active.find_by_id(id) if id
  end
  
  def self.signout(id)
    user_session = UserSession.get_active_session(id)
    if user_session
      user_session.status = 'signed_out'
      user_session.save
    end
  end
  
  def delete_session
    self.status = 'deleted'
    save
  end
end
