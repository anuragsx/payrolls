class ActiveSupport::TestCase
  
  Factory.define :salary_slip, :class => 'SalarySlip' do |s|
    s.employee {|e| e.association(:employee)}
    s.company {|e| e.association(:company)}
    s.salary_sheet {|e| e.association(:salary_sheet)}
  end
end