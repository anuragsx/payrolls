class AdminMailer < ActionMailer::Base

  def signup_information_to_admin(company)
    setup_admin_mail(company, "new company registered - #{company.name}")
    body :name => company.name,
         :email => company.owner.email,
         :subdomain => company.subdomain,
         :address => company.owner.complete_address,
         :mobile => company.owner.address.try(:mobile_number)

  end

  def salary_sheet_information_to_admin(sheet)
    company = sheet.company
    setup_admin_mail(company, "new salary sheet created - #{company.name}")
    body :company => company,
         :sheet => sheet
  end

  def feedback_detail_to_admin(feedback)
    user = feedback.user
    company = user.company
    setup_admin_mail(company, "new feedback posted - #{company.name}")
    body :company => company,
         :feedback => feedback,
         :user => user
  end
  
  protected
  
  def setup_admin_mail(company,subject_suffix)
    recipients   RECIPIENTS
    from         "#{ADMIN_MAILER_FROM_ADDRESS}"
    subject      "[#{MAILER_SUBJECT_PREFIX}] #{subject_suffix}"
    sent_on      Time.now
  end

end