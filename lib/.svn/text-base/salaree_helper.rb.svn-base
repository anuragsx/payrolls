module SalareeHelper
  def got_insurance(company,position)
    @insurance_calculator = InsuranceCalculator.first
    if rand(2) == 1
      CompanyCalculator.create(:company_id => company.id,:calculator => @insurance_calculator, :position => position)
      puts "\tSelected LIC Deductor at #{position}"
      position += 1
      company.employees.each do |e|
        rand(3).times do
          EmployeeInsurancePolicy.create(:employee_id => e.id,
                                         :company_id => company.id,
                                         :monthly_premium => rand(500),
                                         :name => "LIC#{rand(100000)}",
                                         :expiry_date => e.commencement_date + rand(24).months)
        end
      end
    end
    return position
  end

  def got_esi(company,position)
    @esi_types ||= EsiType.all
    @esi_calculator ||= EsiCalculator.first
    if rand(2) == 1
      CompanyEsi.create(:company_id => company.id, :esi_type => @esi_types.rand, :esi_number => Populator.words(1))
      CompanyCalculator.create(:company_id => company.id,:calculator => @esi_calculator, :position => position)
      puts "\tSelected ESI Deductor at #{position}"
      position += 1
    end
    return position
  end

  def got_pt(company,position)
    @zones ||= ProfessionalTaxSlab.all(:select => 'zone').map(&:zone).uniq
    @pt_calculator ||= ProfessionalTaxCalculator.first
    if rand(2) == 1
      CompanyCalculator.create(:company => company,
                               :calculator => @pt_calculator,
                               :position => position)
      puts "\tCreated Professional Tax at #{position}"
      position += 1
      company.employees.each do |employee|
        if rand(2) == 1
          EmployeeProfessionalTax.create(:employee => employee,
                                         :company => company,
                                         :zone => @zones.rand)
        end
      end
    end
    return position
  end

  def got_pf(company,position)
    @pf_types ||= PfType.all
    @pf_calculator ||= PfCalculator.first
    fields = [{:total_pf_contribution => 1000},{:vpf_amount => 300},{:vpf_percent => 10}]
    if rand(2) == 1
      pf = CompanyPf.create(:company => company, :pf_type => @pf_types.rand, :pf_number => Populator.words(1))
      CompanyCalculator.create(:company => company, :calculator => @pf_calculator, :position => position)
      puts "\tSelected Pension Deductor at #{position}"
      position += 1
      company.employees.each do |e|
        if rand(2) == 1
          attrs = fields.rand
          attrs.merge!({:employee => e, :company => company, :company_pf => pf})
          EmployeePension.create(attrs)
        end
      end
    end
    return position
  end

  def got_dearness_relief(company,position)
    @dearness_relief_calculator = DearnessReliefCalculator.first
    if rand(2) == 1
      CompanyLoading.create(:company_id => company.id,
                            :loading_percent => [41,47].rand)
      CompanyCalculator.create(:company_id => company.id,
                               :calculator => @dearness_relief_calculator,
                               :position => position)
      puts "\tSelected Dearness Relief on Basic Allowance at #{position}"
      position += 1
    end
    return position
  end

  def got_loans(company,position)
    @loan_calculator = LoanCalculator.first
    if rand(2) == 1
      CompanyCalculator.create(:company_id => company.id,:calculator => @loan_calculator, :position => position)
      puts "\tSelected Loan Manager Deductor at #{position}"
      position += 1
      company.employees.each do |e|
        ep = e.current_package
        if (rand(2) == 1)
          loan_amount = [100,(ep.basic * 5 / 100.0)].max
          emi = loan_amount / 12
          EmployeeLoan.create!(:employee => e,
                               :company => company,
                               :loan_amount => loan_amount,
                               :created_at => e.commencement_date,
                               :effective_loan_emis_attributes => [{:amount => emi, :employee => e, :created_at => e.commencement_date}])
        end
      end
    end
    return position
  end

  def got_advances(company,position)
    @advances_calculator ||= AdvanceCalculator.first
    if rand(2) == 1
      CompanyCalculator.create(:company_id => company.id,:calculator => @advances_calculator, :position => position)
      puts "\tSelected Advances Manager at #{position}"
      position += 1
    end
    return position
  end

  def got_tds(company,position)
    if false #rand(2) == 1
      tds_calculator = SimpleIncomeTaxCalculator.first
      CompanyCalculator.create(:company_id => company.id,:calculator => tds_calculator, :position => position)
      puts "\tSelected Simple Income Tax Manager Deductor at #{position}"
      position += 1
    else
      tds_calculator = IncomeTaxCalculator.first
      CompanyCalculator.create(:company_id => company.id,:calculator => tds_calculator, :position => position)
      puts "\tSelected Income Tax Manager Deductor at #{position}"
      position += 1
    end
    return position
  end

  def got_expenses(company,position)
    @reimbursement_calculator ||= ReimbursementCalculator.first
    if rand(2) == 1
      CompanyCalculator.create(:company_id => company.id,:calculator => @reimbursement_calculator, :position => position)
      puts "\tSelected Expense Claim Manager at #{position}"
      position += 1
    end
    return position
  end

  def got_bonus(company,position)
    @bonus_calculator = BonusCalculator.first
    if rand(2) == 1
      CompanyCalculator.create(:company_id => company.id, :calculator => @bonus_calculator, :position => position)
      puts "\tSelected Bonus Accruer at #{position}"
      position += 1
    end
    return position
  end

  def got_gratuity(company,position)
    @gratuity_calculator = GratuityCalculator.first
    if rand(2) == 1
      CompanyCalculator.create(:company_id => company.id, :calculator => @gratuity_calculator, :position => position)
      puts "\tSelected Gratuity at #{position}"
      position += 1
    end
    return position
  end

  def pick_package_manager(company,position=2)
    @basic_calculator ||= BasicCalculator.first
    @simple_calculator ||= SimpleAllowanceCalculator.first
    @flexi_calculator ||= FlexibleAllowanceCalculator.first
    has_basic = rand(3)
    if true#has_basic == 0
      CompanyCalculator.create!(:company_id => company.id, :calculator => @basic_calculator, :position => position)
      puts "\tSelected Basic Package Manager at #{position}"
    elsif has_basic == 1
      CompanyCalculator.create!(:company_id => company.id, :calculator => @simple_calculator, :position => position)
      puts "\tSelected Simple Package Manager at #{position}"
      p = 1
      company_heads = SalaryHead.allowance_compatible.all.map do |head|
        allowance = CompanyAllowanceHead.new(:company_id => company.id, :salary_head_id => head.id, :position => p)
        p += 1
        allowance.save
      end
      company_heads = CompanyAllowanceHead.find_all_by_company_id(company.id)
      company.employees.each do |e|
        ep = e.current_package
        company_heads.each do |head|
          EmployeePackageHead.create!(:salary_head => head.salary_head,
                                     :employee_id => e.id,
                                     :company_id => company.id,
                                     :amount => ep.basic * rand(20) / 100.0,
                                     :employee_package_id => ep.id)
        end
      end
    else
      @da ||= SalaryHead.find_by_code("DA")
      @hra ||= SalaryHead.find_by_code("HRA")
      @medical ||= SalaryHead.find_by_code("MED")
      @laundry ||= SalaryHead.find_by_code("LAUNDRY")
      CompanyCalculator.create!(:company_id => company.id, :calculator => @flexi_calculator, :position => position)
      puts "\tSelected Flexi Package Manager at #{position}"
      CompanyFlexiPackage.create!(:company => company, :salary_head => @da,
                                  :lookup_expression => 'company', :position => 1)
      CompanyFlexiPackage.create!(:company => company, :salary_head => @hra,
                                  :lookup_expression => 'company', :position => 1)
      CompanyFlexiPackage.create!(:company => company, :salary_head => @medical,
                                  :lookup_expression => 'employee', :position => 1)
      CompanyFlexiPackage.create!(:company => company, :salary_head => @medical,
                                  :lookup_expression => 'company', :position => 2)
      CompanyFlexiPackage.create!(:company => company, :salary_head => @laundry,
                                  :lookup_expression => 'employee', :position => 1)
      CompanyFlexiPackage.create!(:company => company, :salary_head => @laundry,
                                  :lookup_expression => 'company', :position => 2)
      FlexibleAllowance.create!(:company => company, :head_type => 'Percentage Of Basic',
                                 :value => 50.0, :salary_head => @da,
                                 :leave_dependent => true, :category => company)
      FlexibleAllowance.create!(:company => company, :head_type => 'Percentage Of Basic',
                                 :value => 7.5, :salary_head => @hra,
                                 :leave_dependent => true, :category => company)
      FlexibleAllowance.create!(:company => company, :head_type => 'Constant',
                                 :value => 100.0, :salary_head => @medical,
                                 :leave_dependent => false, :category => company)
      FlexibleAllowance.create!(:company => company, :head_type => 'Constant',
                                 :value => 10.0, :salary_head => @laundry,
                                 :leave_dependent => false, :category => company)
      company.employees.each do |e|
        ep = e.current_package
        %W(MED LAUNDRY).each do |head|
          FlexibleAllowance.create!(:salary_head => SalaryHead.find_by_code(head),
                                    :category => e,
                                    :company => company,
                                    :value => rand(200.0),
                                    :head_type => 'Constant') if (rand(2) == 1)
        end
      end
    end
  end

  def pick_leave_manager(company,position=1)
    @simple_leave_calculator ||= SimpleLeaveCalculator.first
    @leave_accounting_calculator ||= LeaveAccountingCalculator.first
    leave_manager = rand(2)
    if false#leave_manager == 0
      CompanyCalculator.create!(:company_id => company.id, :calculator => @simple_leave_calculator, :position => position)
      puts "\tSelected Simple Leave Calculator at 1"
    else
      CompanyCalculator.create!(:company_id => company.id, :calculator => @leave_accounting_calculator, :position => position)
      CompanyLeave.create!(:company_id => company.id, :rate_of_leave => [12,20].rand,
                          :month_day_calculation => [1,2,3].rand,
                          :month_length => [25,30].rand, :leave_accrual => [1,2].rand)
      puts "\tSelected Leave Accounting Calculator at 1"
    end
  end

  def display_sheet(s)
    s.salary_slips.each do |slip|
      printf("%116s %3d: %10.4f\n",slip.employee.name,slip.leaves,slip.leave_ratio)
      printf("%120s: %10.2f\n","Basic Rate",slip.employee.effective_basic(s.run_date))
      printf("%120s: %10s\n","","-"*10)
      slip.allowance_charges.each do |charge|
        printf("%120s: %10.2f\n",charge.description + " [#{charge.salary_head.name}]",charge.amount)
      end
      printf("%120s: %10s\n","","-"*10)
      printf("%120s: %10.2f\n","Gross",slip.gross)
      printf("%120s: %10s\n","","-"*10)
      slip.deduction_charges.each do |charge|
        printf("%120s: %10.2f\n",charge.description + " [#{charge.salary_head.name}]",charge.amount)
      end
      printf("%120s: %10s\n","","-"*10)
      printf("%120s: %10.2f\n","Deduction",slip.deduction)
      printf("%120s: %10s\n","","-"*10)
      printf("%120s: %10.2f\n","Net",slip.net)
      printf("%120s: %10s\n","","-"*10)
      slip.company_committment_charges.each do |charge|
        printf("%120s: %10.2f\n", charge.description + " [#{charge.salary_head.name}]",charge.amount)
      end
      printf("%120s: %10.2f\n","CTC",slip.extra_cost_to_company)
      printf("%120s: %10.2f\n","SLIP GROSS",slip.extra_cost_to_company + slip.net)
      puts('-'*133)
    end
  end
end
