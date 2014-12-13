class Feedback < ActiveRecord::Base

  belongs_to :user
  #validates_format_of :email, :with => /^([^@\s]{1}+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message=>'does not look like an email address.'
  #validates_presence_of :email
  validates :feedback, :presence => true
end
