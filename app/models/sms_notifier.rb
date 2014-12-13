class SmsNotifier < ActionMessenger::Base
  include ActionController::UrlWriter
  default_url_options[:host] = ActionMailer::Base.default_url_options[:host] # this needs to generate urls 
    
  def salary_sms(slip, number)
    recipients(number)
    text_to_be_sent("Your #{slip.salary_sheet.run_date.to_s(:short_month_and_year)} salary is Rs.#{slip.net}")
  end
  
  def signup(user, number)
    recipients(number)
    text_to_be_sent("Use this token #{user.perishable_token} to activate your account. Visit #{root_url(:subdomain => user.company.subdomain)}")
  end

  def total_salary_sms(sheet, number)
    recipients(number)
    text_to_be_sent("Salary Sheet of #{sheet.run_date.to_s(:short_month_and_year)} has been generated with total amount of Rs.#{sheet.grand_total}")
  end
  
end