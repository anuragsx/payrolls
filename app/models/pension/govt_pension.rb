# To change this template, choose Tools | Templates
# and open the template in the editor.

class GovtPension < PfType
  
  def effective_base_for_company(basic,da,dr)
    basic + dr + (da * 0.5)
  end
  
  def effective_base_for_employee(basic,da,dr)
    (basic + dr)
  end

  def effective_employee_percent
    pension_percent
  end

  def employer_charges(effective_base, vpf_amount)
    [{:amount => pension_contrib(effective_base),
     :salary_head => SalaryHead.code_for_employer_pf}]
  end

end