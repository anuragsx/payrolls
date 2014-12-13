class ActiveSupport::TestCase
  
  Factory.define :leave_type, :class => 'LeaveType' do |l|
    l.sequence(:name) {|n| "Leave_type#{n}"}
  end
end