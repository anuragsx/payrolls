class ActiveSupport::TestCase
  
  Factory.define :salary_sheet, :class => 'SalarySheet' do |s|
    s.run_date Date.today
    s.company {|c| c.association(:company)}
  end
end