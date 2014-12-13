class UserMailer < ActionMailer::Base
  
  def password_reset_instructions(user)
    setup_email(user, "Password Reset Instructions")
    body          :edit_reset_password_url =>
                    edit_reset_password_url(user.perishable_token, :subdomain => user.company.subdomain)
  end

  def email_verification_instructions(user)
    setup_email(user, "Account Activation Instructions")
    body          :activate_account_url => activate_accounts_url(:code => user.perishable_token,
                  :subdomain => user.company.subdomain),
                  :username => user.login,
                  :token => user.perishable_token, :subdomain => user.company.subdomain

  end

  def user_welcome(user)
    setup_email(user, "Welcome to #{user.company.name}")   
    body    :activate_account_url => activate_accounts_url(:code => user.perishable_token,
                  :subdomain => user.company.subdomain),
            :welcome_url => welcome_accounts_url(:subdomain => user.company.subdomain),
            :user => user.full_name,
            :login => user.login,
            :company => user.company.name,
            :token => user.perishable_token
  end

  def feedback_thanks(feedback)
    user = feedback.user
    setup_email(user, "Feedback submitted")
    body          :feedback => feedback,
                  :user => user
    
  end
  
  protected
  def setup_email(user,subject_suffix)
    load_settings
    recipients   user.email
    from         MAILER_FROM_ADDRESS
    subject      "[#{user.company_name}] #{subject_suffix}"
    sent_on       Time.now
  end

  def setup_admin_mail(company,subject_suffix)
    load_settings
    recipients   RECIPIENTS
    from         "#{MAILER_FROM_ADDRESS}"
    subject      "#{MAILER_SUBJECT_PREFIX} #{subject_suffix}"
    sent_on      Time.now
  end

  def load_settings
    return true if Rails.env == "development"
    options = YAML.load_file("#{RAILS_ROOT}/config/action_mailer.yml")[RAILS_ENV]["usermailer"]
    @@smtp_settings = {
      :address => options["address"],
      :port => options["port"],
      :domain => options["domain"],
      :authentication => options["authentication"],
      :user_name => options["user_name"],
      :password => options["password"]
    }
  end

end