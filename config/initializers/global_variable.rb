I18n.default_locale = 'en'
LANGUAGES = {
  'English' => 'en',
  "\xE0\xA4\xB9\xE0\xA4\xBF\xE0\xA4\x82\xE0\xA4\xA6\xE0\xA5\x80 " => 'hi'
}
TLD_LENGTH = 1 if Rails.env == "development"
TLD_LENGTH = 1 if Rails.env == "production"
TLD_LENGTH = 0 if Rails.env == "test"
FINANCIAL_YEAR_START = 4
COUNTRY = 'INDIA'
STATE = ["Rajasthan", "Delhi"]
CONFIRM_DELETE = "Are you sure?\nThis can not be undone!"
DEFAULT_INSURANCE_COMPANY = "Life Insurance Corporation"
OAUTH_10_SUPPORT = true
REFRESH_SECONDS = 5

ActionMailer::Base.default_url_options[:host] = 'salaree.com'

#Paperclip::Attachment.default_options[:path] = ":Rails.root/public/system/:class/:attachment/:id/:style/:basename.:extension"
#Paperclip::Attachment.default_options[:url] = "/system/:class/:attachment/:id/:style/:basename.:extension"

#SubdomainFu.tld_sizes = {:development => 1,
#                         :test => 0,
#                         :production => 1} # set all at once (also the defaults)

$subdomain_exclusion = %w{salaree asset asset0 asset1 asset2 asset3 admin sanghi marketing pics docs
                          www mail mobile static ftp smtp pop pop3 salary administration images image
                          blog sales risingsun blogs home status url ssh svn make create cms content
                          signup risingsun} + ('a'..'z').to_a

MonthsForSelect = Date::MONTHNAMES.map{|x|[x,Date::MONTHNAMES.index(x)]}
YearRange = (5.years.ago.year .. Date.today.year)
Round = [0,1,2]

EDUCATION_CESS = 0.03
INDIAN_METROS = ['New Delhi','Delhi','Mumbai','Bombay','Calcutta','Kolkata','Kokatta','Madras','Chennai'].map(&:upcase)
CONVEYANCE_THRESHOLD = 800
SMS_ENABLED = true && File.exists?("#{Rails.root}/config/messenger.yml")
MAILCHIMP_LIST = "Test Signups"

#TODO
raw_config = File.read("/home/anurag/projects/payrolls/config/app_config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys
#TODO
Date::DATE_FORMATS.merge!(:month_and_year => "%B %Y")
Time::DATE_FORMATS.merge!(:month_and_year => "%B %Y")
Date::DATE_FORMATS.merge!(:short_month_and_year => "%b %Y")
Time::DATE_FORMATS.merge!(:short_month_and_year => "%b %Y")
Date::DATE_FORMATS.merge!(:short_month => "%b")
Time::DATE_FORMATS.merge!(:short_month => "%b")
Time::DATE_FORMATS.merge!(:salaree_time => '%d %b %Y - %I:%M%p')
Date::DATE_FORMATS.merge!(:date_month_and_year => "%d %B %Y")
Time::DATE_FORMATS.merge!(:date_month_and_year => "%d %B %Y")
Date::DATE_FORMATS.merge!(:month_date_and_year => "%B %d %Y")
Time::DATE_FORMATS.merge!(:month_date_and_year => "%B %d %Y")
Time::DATE_FORMATS.merge!(:for_param => "%b%Y")
Date::DATE_FORMATS.merge!(:for_param => "%b%Y")
Time::DATE_FORMATS.merge!(:date_and_month => "%d %B")
Date::DATE_FORMATS.merge!(:date_and_month => "%d %B")

require 'forms_with_buttons'
require 'form_helper'
#require 'prawn/format' #TODO
require 'subdomain_company'
require 'num_to_words'
require 'short_random'
require 'prawn/security'
#require 'oauth/controllers/provider_controller'
MAILER_FROM_ADDRESS = "Friends at test.com"
ADMIN_MAILER_FROM_ADDRESS = %W(no-reply@test.com)
SITE_NAME = "Payroll.com"
RECIPIENTS = ["anuraag.jpr@gmail.com"]
MAILER_SUBJECT_PREFIX = "payroll"
DOMAIN = "payroll.com"
=begin
ActionMailer::Base.smtp_settings = {
  :address => "smtp.1and1.com",
  :port => 25,
  :domain => "http://salaree.com",
  :authentication => :plain,
  :user_name => "no-reply@risingsuntech.net",
  :password => "risingsun.noreply"
}
=end

ActionMailer::Base.smtp_settings = {
    :address => "smtp.1and1.com",
    :port => 25,
    :domain => "",
    :authentication => :plain,
    :user_name => "",
    :password => ""
}


Date.fiscal_zone = :india
Time.zone = "Mumbai"

class Fixnum
  def financial_months(&block)
    first_date = Date.financial_year_start(self)
    (1..12).map do |m|
      d = first_date + (m - 1).months
      block_given? ? yield(d) : d
    end
  end

  def calendar_months(&block)
    (1..12).map do |m|
      d = Date.new(self,m,1)
      block_given? ? yield(d) : d
    end
  end

  def formatted_fy
    "#{self}-#{self+1}"
  end
end

class TrueClass
  def pretty_print
    "Yes"
  end
end

class FalseClass
  def pretty_print
    "No"
  end
end

class Date
  def self.end_of_time
    new(9999,12,30)
  end

  def end_of_time?
    self == Date.end_of_time
  end

  def month_dates
    (self.beginning_of_month..self.end_of_month).map{|x|x}
  end
  
  def exempt_block
    first_block_year = 1986
    return nil if self.year < first_block_year
    block = first_block_year
    current_year = Date.today.year
    while !(block < current_year && (block + 3) > current_year)
      return (block.to_s + "-" + (block + 3).to_s) if block <=  self.year && (block + 3) >=  self.year
      block = block + 4
    end
  end

  def logged_in?

  end

end