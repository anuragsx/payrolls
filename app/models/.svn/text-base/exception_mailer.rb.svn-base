class ExceptionMailer < ActionMailer::Base

  def exception_notification(exception, data={})
    content_type "text/plain"

    subject    "[#{data[:company].try(:subdomain)}]#{ExceptionNotifier.email_prefix} (#{exception.class}) #{exception.message.inspect}"

    recipients ExceptionNotifier.exception_recipients
    from       ExceptionNotifier.sender_address

    body       data.merge({:exception => exception, 
                  :backtrace => exception.backtrace,
                  :rails_root => RAILS_ROOT, :data => data})
  end
  

end
