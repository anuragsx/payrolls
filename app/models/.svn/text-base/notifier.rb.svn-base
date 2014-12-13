# app/models/notifier.rb
class Notifier < ActionMailer::Base
  
  def sign_up_information(f)
    load_settings
    recipients    f.email
    from          MAILER_FROM_ADDRESS
    subject       "Salaree.com Launched!"
    content_type "text/html"
    sent_on       Time.now
    body :email => f.email
  end

  def load_settings
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