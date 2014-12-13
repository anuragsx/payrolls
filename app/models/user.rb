class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :login, :email, :password, :password_confirmation, :address_attributes

  acts_as_authentic do |c|
    c.validations_scope = :company_id
    c.disable_perishable_token_maintenance = true # for direct activation
    c.login_field = 'login'
    c.maintain_sessions = true
    #c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    #c.validate_email_field = false
    #c.my_config_option = :login
  end
  
  attr_accessor :terms_of_service
  
  belongs_to :company
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address, :allow_destroy => true
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken",:order=>"authorized_at desc",:include=>[:client_application]


  validates_less_reverse_captcha

  validates :email, :presence => true#, :message => "Cannot be left blank"
  validates :login, :presence => true#,:message => "Cannot be left blank"
  #validates_uniqueness_of :email, :message => "Already taken"

  validates :email, :format => { :with => /^([^@\s]{1}+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'does not look like an email address.' }

  #_format_of :email, :with => /^([^@\s]{1}+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
   #                           :message=>'does not look like an email address.'

  before_save :add_user_to_mailchimp

  def add_user_to_mailchimp
    if self.activate_changed? && self.activate_was != true
      self.add_user_to_mailchimp_list if Rails.env.production?
    end
  end

  def add_user_to_mailchimp_list
    MailChimp.subscribe_user(self) if MAILCHIMP_LIST
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
  end

  def deliver_email_verification_instructions!
    reset_perishable_token!
    #UserMailer.send_later(:deliver_email_verification_instructions,self) #TODO removed delayed job
    UserMailer.email_verification_instructions(self).deliver
    #self.send_later(:send_signup_sms) #TODO need to fix action messanger.
    AdminMailer.signup_information_to_admin(self.company).deliver if Rails.env.production?
  end

  def send_signup_sms
    SmsNotifier.send_signup(self, self.address.try(:mobile_number)) if self.address.try(:mobile_number)&& Rails.env.production?  && SMS_ENABLED
  end
  
  def full_name
    full_name = [first_name,last_name].compact.join(' ').titleize
    full_name.blank? ?  login : full_name
  end
  
  def company_name
    self.company.name if self.company
  end

  def complete_address
    [address.address_line1,address.address_line2,address.address_line3,address.city, address.pin_code_with_label, address.state].compact.reject{|x|x.blank?}.join(", ")
  end

end
