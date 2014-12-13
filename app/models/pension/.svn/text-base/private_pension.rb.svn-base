# To change this template, choose Tools | Templates
# and open the template in the editor.

class PrivatePension < PfType
  extend ActiveSupport::Memoizable

  def effective_base_for_company(basic,da,dr=nil)
    [pf_basic_threshold,(basic + da).abs].min
  end

  def effective_base_for_employee(basic,da,dr=nil)
    effective_base_for_company(basic,da)
  end

  def effective_employee_percent
    pension_percent + epf_percent
  end
  
  def epf_contrib(effective_base)
    (employee_contrib(effective_base) - pension_contrib(effective_base)).round
  end

  def admin_contrib(effective_base)
    (effective_base * admin_percent / 100.0).round
  end

  def edli_contrib(effective_base)
    (effective_base * edli_percent / 100.0).round
  end

  def inspection_contrib(effective_base)
    (effective_base * inspection_percent / 100.0).round
  end

  def employer_charges(effective_base,vpf_amount)
    [{:amount => pension_contrib(effective_base) + vpf_amount, :salary_head => SalaryHead.code_for_employer_pf},
     {:amount => epf_contrib(effective_base), :salary_head => SalaryHead.code_for_employer_epf}]
  end

  def employer_charges_for_sheet(effective_base)
    [{:amount => admin_contrib(effective_base), :salary_head => SalaryHead.code_for_employer_pf_admin},
     {:amount => edli_contrib(effective_base), :salary_head => SalaryHead.code_for_employer_pf_edli},
     {:amount => inspection_contrib(effective_base), :salary_head => SalaryHead.code_for_employer_pf_inspection}]
  end
end