class UserSession < Authlogic::Session::Base
  allow_http_basic_auth true
  remember_me_for 1.day
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

  def persisted?
    false
  end

end