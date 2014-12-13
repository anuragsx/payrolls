class ActiveSupport::TestCase
  
  Factory.define :salary_slip_charge do |s|
    s.employee {|e| e.association(:employee)}
    s.company {|e| e.association(:company)}
    s.salary_sheet {|e| e.association(:salary_sheet)}
    s.salary_slip {|e| e.association(:salary_slip)}
    s.salary_head {|e| e.association(:salary_head)}
    s.charge_date {Date.today - 365}
  end
  
end