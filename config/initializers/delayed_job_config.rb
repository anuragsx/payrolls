=begin

Delayed::Worker.destroy_failed_jobs = false
#silence_warnings do
  #Delayed::Job.const_set("MAX_ATTEMPTS", 3)
  #Delayed::Job.const_set("MAX_RUN_TIME", 5.minutes)
#end


def max_attempts
  3
end


def max_run_time
  5.minutes
end

module Delayed
  class Job < ActiveRecord::Base

    after_save :send_notification

    def send_notification
      if last_error
        begin
          raise last_error
        rescue Exception => e
          logger.error("Delayed Job exception #{e.message}")
          ExceptionMailer.deliver_exception_notification(e) if Rails.env.production?
        end
      end
    end
  end
end
module Delayed
  module MessageSending
    def send_later(method, *args)
      if RAILS_ENV=="test"
        Delayed::PerformableMethod.new(self, method.to_sym, args).perform
      else
        Delayed::Job.enqueue Delayed::PerformableMethod.new(self, method.to_sym, args)
      end
    end

  end
end

=end