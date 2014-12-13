class OauthToken < ActiveRecord::Base
  belongs_to :client_application
  belongs_to :user


  validates :token, :uniqueness => true
  validates :client_application, :token, :secret, :presence => true

  before_validation_on_create :generate_keys

  scope :validate_token, :conditions => 'oauth_tokens.invalidated_at is null and oauth_tokens.authorized_at is not null'
  scope :for_client, lambda{|c| {:conditions => {:client_application_id => c}}}
  scope :for_user, lambda{|u|{:conditions => ["user_id = ?",u]}}
  def invalidated?
    invalidated_at != nil
  end
  
  def invalidate!
    update_attribute(:invalidated_at, Time.now)
  end
  
  def authorized?
    authorized_at != nil && !invalidated?
  end
    
  def to_query
    "oauth_token=#{token}&oauth_token_secret=#{secret}"
  end
    
  protected
  
  def generate_keys
    oauth_token = client_application.oauth_server.generate_credentials
    self.token = oauth_token[0][0,20]
    self.secret = oauth_token[1][0,40]
  end
end
