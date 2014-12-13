class ActiveSupport::TestCase

  Factory.define :user do |r|
    r.sequence(:login) {|n| "user_#{n}" }
    r.company  {|c| c.association(:company)}
    r.password 'user123'
    r.password_confirmation 'user123'
    r.activate true
    r.email 'admin@salaree.com'
  end

  Factory.define :swati, :class => User do |r|
    r.login 'swati'
    r.company  {|c| c.association(:company)}
    r.password 'swati'
    r.password_confirmation 'swati'
    r.activate true
    r.email 'admin@salaree.com'
  end


end