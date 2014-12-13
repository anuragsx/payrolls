# To change this template, choose Tools | Templates
# and open the template in the editor.

class MailChimp

  attr_reader :hominid
  
  def initialize
    @hominid = Hominid.new
  end
  
  def find_list_id(list_name = MAILCHIMP_LIST)
    mailing_list = self.hominid.lists
    unless mailing_list.nil?
      mailing_list.find {|list| list["name"] == list_name}["id"]
    end
  end

  def self.subscribe_user(user)
    mc = self.new
    list_id = mc.find_list_id
    mc.hominid.subscribe(list_id, user.email, :email_type => 'html')
  end
end
