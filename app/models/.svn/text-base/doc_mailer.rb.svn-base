class DocMailer < ActionMailer::Base

  def sent_salary_sheet(user,salary_sheet)
    load_settings
    @subject      = "[#{user.company_name}] Salary Sheet for #{salary_sheet.formatted_run_date}"
    @recipients   = user.email
    @from         = MAILER_FROM_ADDRESS
    @sent_on      = Time.new
    part :content_type => "multipart/alternative" do |p|
      p.part :body => render_message("sent_salary_sheet.html.erb", :salary_sheet => salary_sheet)
    end
    part :content_type => "multipart/mixed" do |p|
      p.attachment "application/pdf" do |a|
        if File.exist?(salary_sheet.doc.path)
          File.open(salary_sheet.doc.path, 'rb') do |file|
            a.body = file.read
          end
        end
        a.filename = "Salary_Sheet for #{salary_sheet.formatted_run_date}.pdf"
      end
    end
  end

  def sent_salary_slip(s, company)
    load_settings
    @subject      = "[#{company.name}] Salary slip for #{s.salary_sheet.formatted_run_date}"
    @recipients   = s.employee.email
    @from         = MAILER_FROM_ADDRESS
    @sent_on      = Time.new
    part :content_type => "multipart/alternative" do |p|
      p.part :body => render_message("sent_salary_slip.html.erb", :salary_slip => s)
    end
    part :content_type => "multipart/mixed" do |p|
      p.attachment "application/pdf" do |a|
        if File.exist?(s.doc.path)
          File.open(s.doc.path, 'rb') do |file|
            a.body = file.read
          end
        end
        a.filename = "Salary_Slip for #{s.salary_sheet.formatted_run_date}.pdf"
      end
    end
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