class User < ActiveRecord::Base
  attr_accessor :remember
  attr_readonly :id, :username, :display_name, :created_at
  attr_accessible :username, :email, :password, :password_confirmation, as: :join
  attr_accessible :email, :status, as: :admin
  
  has_many :sessions, class_name: 'UserSession'
  
  after_validation :clear_password_digest_errors
  before_create :set_display_and_username
  
  has_secure_password
  validates :username, presence: true, length: { minimum: 3, maximum: 30, allow_blank: true }, format: { with: /^[a-zA-Z0-9\-_]+$/, allow_blank: true }, uniqueness: { case_sensitive: false, if: "errors[:username].empty?" }
  validates :status, inclusion: { in: ['active', 'deleted', 'banned', 'admin'] }
  validates :email, length: { maximum: 100 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, allow_blank: true }
  validates :password, presence: true, length: { minimum: 6, allow_blank: true }, if: :password_required?
  
  def to_param
    display_name
  end
  
  def self.active
    where(status: ['active', 'admin'])
  end
  
  def self.admin
    where(status: 'admin')
  end
  
  def self.get_by_username(username)
    active.find_by_username(username.downcase) if username
  end
  
  def self.admin_get_by_username(username)
    find_by_username(username.downcase) if username
  end
  
  def self.get_by_token(token)
    active.find_by_forgot_password_token(token) if token
  end
  
  def change_email(unencrypted_password, params)
    if params[:email]
      self.email = params[:email]
      if authenticate_change(unencrypted_password)
        save
      else
        false
      end
    else
      errors.add(:base, 'Error updating email')
      false
    end
  end
  
  def change_password(unencrypted_password, params)
    if authenticate_change(unencrypted_password)
      update_password(params)
    end
  end
  
  def delete_user(unencrypted_password)
    if authenticate_change(unencrypted_password)
      self.status = 'deleted'
      save
    end
  end
  
  def self.signin(params)
    user = get_by_username(params[:username])
    user if user && params[:password] && user.authenticate(params[:password])
  end
  
  def self.forgot_password(params)
    user = get_by_username(params[:username])
    if user
      if not user.email.blank?
        user.forgot_password_token = user.id.to_s+'-'+Digest::SHA1.hexdigest(Time.now.to_s)
        user.forgot_password_at = Time.now
        user.save
      else
        user.errors.add(:base, 'No email is linked to this username')
      end
    else
      user = User.new
      user.username = params[:username]
      user.errors.add(:username, 'not found')
    end
    user
  end
  
  def self.reset_password(token, params)
    user = get_by_token(token)
    user.update_password(params) if user
    user
  end
  
  def update_password(params)
    self.password = params[:password] || ''
    self.password_confirmation = params[:password_confirmation] || ''
    self.forgot_password_token = nil
    self.forgot_password_at = nil
    save
  end
  
  private
  
  def set_display_and_username
    if username
      self.display_name = username
      self.username = username.downcase
    end
  end
  
  def clear_password_digest_errors
    errors[:password_digest].clear if errors[:password].any?
  end
  
  def password_required?
    new_record? or password
  end
  
  def authenticate_change(unencrypted_password)
    if authenticate(unencrypted_password)
      true
    else
      errors.add(:base, 'Password is incorrect')
      false
    end
  end
end
