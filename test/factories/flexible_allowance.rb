class ActiveSupport::TestCase
  
  Factory.define :constant_flexible_allowance, :class => 'FlexibleAllowance' do |s|
    s.category {|c| c.association(:company)}
    s.company  {|c| c.association(:company)}
    s.salary_head  {|c| c.association(:salary_head)}
    s.value 1
    s.head_type "Constant"
    s.leave_dependent true
  end

  Factory.define :percent_of_basic_flexible_allowance, :class => 'FlexibleAllowance' do |s|
    s.category {|c| c.association(:company)}
    s.company  {|c| c.association(:company)}
    s.salary_head  {|c| c.association(:salary_head)}
    s.value 1
    s.head_type "Percentage Of Basic"
    s.leave_dependent true
  end

  Factory.define :flexible_allowance, :class => 'FlexibleAllowance' do |s|
    s.category {|c| c.association(:company)}
    s.company  {|c| c.association(:company)}
    s.salary_head  {|c| c.association(:salary_head)}
    s.company_flexi_package {|c| c.association(:company_flexi_package)}
    s.value 1
    s.head_type "Percentage Of Basic"
    s.leave_dependent true
  end
end